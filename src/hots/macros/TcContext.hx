package hots.macros;





#if (macro || display)
import hots.TC;
import hots.macros.utils.Utils;
import scuts.core.Log;
import scuts.core.macros.Lazy;
import scuts.core.types.Tup2;
import scuts.core.types.Tup3;
import scuts.mcore.Check;
import scuts.mcore.extensions.TypeExt;
import scuts.mcore.MType;
import scuts.mcore.Select;
import scuts.Scuts;
import scuts.core.types.Either;
import scuts.mcore.Parse;
import scuts.mcore.MContext;
import haxe.macro.Context;
import haxe.macro.Type;
import haxe.macro.Expr;
import scuts.mcore.Make;
import scuts.core.types.Option;
import scuts.mcore.Print;
import hots.macros.TcRegistry;
import hots.macros.Data;

using scuts.core.extensions.ArrayExt;
using scuts.core.extensions.OptionExt;
using scuts.core.Log;
using scuts.mcore.extensions.TypeExt;
using scuts.mcore.extensions.ExprExt;
using scuts.core.extensions.StringExt;
using scuts.core.extensions.EitherExt;
using scuts.mcore.extensions.TypeExt;
using scuts.core.extensions.FunctionExt;

private typedef SType = scuts.mcore.Type;



#end

class TcContext 
{
  
  @:macro public static function forInstance (typeClass:ExprRequire<Class<TC>>, exprOrType:Expr) {
    return tc1(exprOrType, typeClass); 
  }
  
  @:macro public static function tc(exprOrType:Expr, typeClass:ExprRequire<Class<TC>>, ?contextClasses:ExprRequire<Array<TC>>) 
  {
    var e = tc1(exprOrType, typeClass, contextClasses);
    //trace(Print.expr(e));
    return e;
  }
  
  #if (macro || display)
  public static function tc1 (exprOrType:Expr, tc:Expr, ?context:Expr) {
    
    
    
    var contextClasses = Check.isConstNull(context) 
      ? []
      : Select.selectEArrayDeclValues(context)
        .map(function (x) {
          return x.map(function (e) return {
            var type = MContext.typeof(e).getOrError("Context must be a constant Array of Expressions");
            
            return Tup2.create(type, e);
          });
        }).getOrElseConst([]);
    //trace(contextClasses);

  // expr can be a value or a type
    var exprType = Context.typeof(exprOrType);
    
    var expr = switch (exprType) {
      case TType(t, p):
        var dt = t.get();
        if (dt.name.indexOf("#") == 0) 
        {
          if (dt.params.length > 0) 
          {
            Scuts.macroError("Types with parameters are not supported as first parameter.", exprOrType.pos);
          } 
          else 
          {
            // make a complex type
            var ct = {
              var typePath = Make.typePath(dt.pack, dt.name.substr(1),[]);
              ComplexType.TPath(typePath);
            }
            Make.block([Make.varExpr("a", ct), Make.constIdent("a")]);
          }
        }
        else 
        {
          exprOrType;
        }
      default: exprOrType;
    }

    var tcType = switch (Context.typeof(tc)) {
      case TType(dt, params):
        var p = dt.get().pack;
        Context.getType((p.length > 0 ? p.join(".") + "." : "") + dt.get().name.substr(1));
      default: Scuts.macroError("Invalid type");
    }
    return resolve(exprType, tcType, contextClasses)
      .getOrElse(handleResolveError);
  }
  
  public static function handleResolveError <T>(e:ResolveError):T 
  {
    function errStr (e:ResolveError) return switch (e) 
    {
      case InvalidTypeClass(t): 
        "Invalid Type Class";
      case NoInstanceFound(tcId, exprType): 
        "Cannot find Type class Instance of " + tcId + " for type " + Print.type(exprType);
      case MultipleInstancesNoneInScope(tcId, exprType): 
        "Cannot resolve Type Class " + tcId + " for type " + 
            Print.type(exprType) + ".\nMultiple type classes were found and none of them is in scope.";
      case MultipleInstancesWithScope(tcId, exprType):
        "Cannot resolve Type Class " + tcId + " for type " + 
            Print.type(exprType) + ". Multiple type classes were found and more than one is in scope.";
      case DependencyErrors(err):
        err.map(errStr).join("\n");
    };
    return Scuts.macroError(errStr(e));
  }
  
  
  public static function resolve (exprType:Type, tcType:Type, contextClasses:Array<Tup2<Type, Expr>>, level:Int = 0):Either<ResolveError, Expr>
  {
    function handleMultipleInstances (tcId, filtered:Array<Tup2<TypeClassInstanceInfo, Mapping>>)
    {
      // we have multiple compatible instances in the registry, check if one of them is in using scope
      var inScope = filtered.filter(function (x) return isInstanceInUsingScope(x._1));
      return switch (inScope.length) 
      {
        case 0: // None in scope -> Error
          Left(MultipleInstancesNoneInScope(tcId, exprType));
        case 1: // only one in scope, fine 
          var tc = inScope[0];
          makeInstanceExpr(tc._1, tc._2, contextClasses, level);
        default: 
          // More than one in scope -> Error
          Left(MultipleInstancesWithScope(tcId, exprType));
      }
    }
    function f (type): Either<ResolveError, Expr>
    {
      var ct = type._1;
      
      var tcId = SType.getFullQualifiedTypeName(ct.get());
      
      var info = TcRegistry.registry.get(tcId);
      
      
      var compatibleTcInstances = info.map(
        function (x) {
          return 
            Utils.typeIsCompatibleTo(exprType, x.tcParamTypes[0], x.allParameters)
            .map(function (m) return Tup2.create(x, m));
        }
      ).catOptions();
      
      return (switch (compatibleTcInstances.length) {
        case 0: 
          Utils.getOfContainerType(exprType)
          .toRight(function () return NoInstanceFound(tcId, exprType))
          .flatMapRight( function (x) return resolve(x, tcType, contextClasses, level+1));
        case 1: 
          var info = compatibleTcInstances[0]._1;
          
          var mapping = compatibleTcInstances[0]._2;
          makeInstanceExpr(info, mapping, contextClasses, level);

        default: 
          // we've got multiple type classes, check if only one of them is in using scope
          handleMultipleInstances(tcId, compatibleTcInstances);
      });
    }
    
    // type classes passed as context expressions are always preferred, check if there's a matching type class passed as context
    var classTypeToSearch = Utils.replaceContainerElemType(tcType, exprType);
    var tcInContextFound = classTypeToSearch.flatMap(function (x) {
      var wildcards1 = (function () return MContext.getLocalTypeParameters(x)).lazyThunk();
      
      return contextClasses.some(function (c) {
        
        var cType = c._1;
        var wildcards2 = MContext.getLocalTypeParameters(cType);
        var allWildcards = wildcards1().union(wildcards2, TypeExt.eq);
        return MType.isInstanceOf (cType.toComplexType(allWildcards), x.toComplexType(allWildcards));
      });
    });
    
    return switch (tcInContextFound) 
    {
      // the type class is passed as a context parameter
      case Some(x): Right(x._2);
      // we need to resolve the type class based on registry and using scope
      case None:
        tcType.asClassType()
        .toRight(function () return ResolveError.InvalidTypeClass(tcType))
        .flatMapRight(f);
    }
    

  }
  
  
  public static function makeInstanceExpr (info:TypeClassInstanceInfo, mapping:Mapping, contextClasses:Array<Tup2<Type, Expr>>,level:Int):Either<ResolveError, Expr> {
   
    var deps = info.dependencies;
    
    var callArgs = 
      deps.map(function (x) return Utils.remap(x._1, mapping))
      .map(function (x) return switch (x) {
        case TInst(t, params):
          resolve(params[0], x, contextClasses, level+1);

        default: Scuts.unexpected();
      });
    
    var acc = 
      callArgs.foldLeft(
        function (acc:Tup2<Array<ResolveError>, Array<Expr>>, c) 
          return switch (c) { 
            case Left(l): Tup2.create(acc._1.insertElemBack(l), acc._2);
            case Right(r): Tup2.create(acc._1, acc._2.insertElemBack(r));
          }, 
        Tup2.create([], [])
      );

    return 
      if (acc._1.length > 0) 
        Left(DependencyErrors(acc._1)) // has errors
      else 
      {
        var pack = info.instance.pack;
        var module = SType.getModule(info.instance);
        var name = info.instance.name;

        Right(Make.type(pack, name, module).field("get").call(acc._2));
      }
  }
  
  public static function isInstanceInUsingScope (instanceInfo:TypeClassInstanceInfo) 
  {
    var callField = instanceInfo.usingCall;
      var doCall = 
        Make.type(["hots", "macros", "internal"], "UsingScope").field(callField).call([]);
        
      return MContext.typeof(doCall).isSome();
  }
  
  
  
  #end
  
  
}