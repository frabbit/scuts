package hots.macros;

#if (macro || display)
import hots.TC;
import hots.macros.utils.Utils;
import scuts.core.extensions.Tup2s;
import scuts.core.Log;
import scuts.core.macros.Lazy;
import scuts.core.types.Tup2;
import scuts.core.types.Tup3;
import scuts.mcore.Check;
import scuts.mcore.extensions.Types;
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
import hots.macros.Registry;
import hots.macros.Data;

using scuts.core.extensions.Arrays;
using scuts.core.extensions.Options;
using scuts.core.Log;
using scuts.mcore.extensions.Types;
using scuts.mcore.extensions.Exprs;
using scuts.core.extensions.Strings;
using scuts.core.extensions.Eithers;
using scuts.mcore.extensions.Types;
using scuts.core.extensions.Functions;

private typedef SType = scuts.mcore.Type;



class Resolver 
{

  static function getExprType (e:Expr):Type
  {
    function eType () return Context.typeof(e);
    
    function fromConst (c:Constant) return switch (c) 
    {
      case CString(s): 
        if (s.charAt(0) == "#") 
        {
          Parse.parseToType(s.substr(1)).getOrError("Cannot parse the expression, syntax error");
        }
        else eType();
      default: eType();
    }
    
    function fromDefType (t:Ref<DefType>) 
    {
      var dt = t.get();
      return if (dt.name.indexOf("#") == 0) 
      {
        if (dt.params.length > 0) 
        {
          Scuts.macroError("Types with parameters are not supported as first parameter.", e.pos);
        } 
        else 
        {
          // make a complex type
          var ct = {
            var typePath = Make.typePath(dt.pack, dt.name.substr(1),[]);
            ComplexType.TPath(typePath);
          }
          Context.typeof(Make.block([Make.varExpr("a", ct), Make.constIdent("a")]));
        }
      }
    }
    
    return switch (e.expr) 
    {
      case EConst(co):
        fromConst(co);
      case EVars(vars):
        var t = vars[0].type;
        var e = macro ( { var x :  $t = null; x; } );
        Context.typeof(e);
      default: 
        switch (Context.typeof(e)) {
          case TType(t, _):
            fromDefType(t);
          default:
            eType();
        }
    };
  }
  
  public static function tc1 (exprOrType:Expr, tc:Expr, ?context:Expr) 
  {
    function extractContextInstances(x:Array<Expr>) 
    {
      function extractTypeAndExpr (e:Expr) return {
        var type = MContext.typeof(e).getOrError("Context must be a constant Array of Expressions");
        
        return Tup2.create(type, e);
      }
      
      return x.map(extractTypeAndExpr);
    }
    
    var contextInstances = 
      if(Check.isConstNull(context)) []
      else 
        Select.selectEArrayDeclValues(context)
        .map(extractContextInstances).getOrElseConst([]);

    // expr can be a value or a type, or a type included in a const string starting with # 
    var eType = function () return Context.typeof(exprOrType);
    var exprType = getExprType(exprOrType);
    
    
    var tcType = switch (Context.typeof(tc)) 
    {
      case TType(dt, params):
        var p = dt.get().pack;
        Context.getType((p.length > 0 ? p.join(".") + "." : "") + dt.get().name.substr(1));
      default: Scuts.macroError("Invalid type");
    }
    return resolve(exprType, tcType, contextInstances)
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
        
      case MultipleInstancesNoneInScope(tcId, exprType, instanceTypes): 
        
        var instanceTypesStr = instanceTypes.map(MType.getFullQualifiedImportName).join(",");
        
        "Cannot resolve Type Class " + tcId + " for type " + Print.type(exprType) + ".\n" + 
        "Multiple type classes were found and none of them is in scope.\n" + 
        "Instances: " + instanceTypesStr;
            
      case MultipleInstancesWithScope(tcId, exprType):
        
        "Cannot resolve Type Class " + tcId + " for type " +  Print.type(exprType) + ".\n" + 
        "Multiple type classes were found and more than one is in scope.";
        
      case DependencyErrors(err):
        err.map(errStr).join("\n");
    };
    return Scuts.macroError(errStr(e));
  }
  
  
  public static function resolve (exprType:Type, tcType:Type, contextInstances:Array<Tup2<Type, Expr>>, level:Int = 0):Either<ResolveError, Expr>
  {

    function handleMultipleInstances (tcId, filtered:Array<Tup2<TypeClassInstanceInfo, Mapping>>)
    {
      // we have multiple compatible instances in the registry, check if one of them is in using scope
      var inUsingScope = filtered.filter(Tup2s.first.next(isInstanceInUsingScope));
      return switch (inUsingScope.length) 
      {
        case 0: // None in scope -> Error
          Left(MultipleInstancesNoneInScope(tcId, exprType, filtered.map(function (x) return x._1.instance)));
        case 1: // only one in scope, fine 
          var tc = inUsingScope[0];
          makeInstanceExpr(tc._1, tc._2, contextInstances, level);
        default: 
          // More than one in scope -> Error
          Left(MultipleInstancesWithScope(tcId, exprType));
      }
    }
    function findTypeClassInRegistry (type): Either<ResolveError, Expr>
    {
      var ct = type._1;
      
      var tcId = SType.getFullQualifiedTypeName(ct.get());
      
      var info = Registry.registry.get(tcId);
      
      function getTypeWithMapping (x:TypeClassInstanceInfo) 
      {
        var res = try 
          Utils.typeIsCompatibleTo(exprType, x.tcParamTypes[0], x.allParameters)
        catch (e:Dynamic) 
          Scuts.error(e);
        return res.map(Tup2.create.partial1(x));
      }
      
      var compatibleTcInstances = info.map(getTypeWithMapping).catOptions();
      
      return switch (compatibleTcInstances.length) 
      {
        case 0: 
          // no type class found
          function notFound () return NoInstanceFound(tcId, exprType);
          function resolveType (x) return resolve(x, tcType, contextInstances, level + 1);
          
          // if our exprType is an Of type like Of<Option<In>, X> we can try to search for
          // the typeclass of the container type like Option<In>
          Utils.getOfContainerType(exprType)
            .toRight(notFound)
            .flatMapRight(resolveType);
        case 1: 
          // we found exactly one type class, so return the expression
          var info = compatibleTcInstances[0]._1;
          var mapping = compatibleTcInstances[0]._2;
          makeInstanceExpr(info, mapping, contextInstances, level);

        default: 
          // we've got multiple type classes, check if only one of them is in using scope
          handleMultipleInstances(tcId, compatibleTcInstances);
      };
    }
    
    // type classes passed as context expressions are always preferred, check if there's a matching type class passed as context
    var classTypeToSearch = Utils.replaceContainerElemType(tcType, exprType);
    
    function findTypeClassInContextInstances(x:Type) 
    {
      var wildcards1 = (function () return MContext.getLocalTypeParameters(x)).lazyThunk();
      
      function isInstanceOfTypeClass(c:Tup2<Type, Expr>) {
        var cType = c._1;
        var wildcards2 = MContext.getLocalTypeParameters(cType);
        var allWildcards = wildcards1().union(wildcards2, Types.eq);
        return MType.isInstanceOf (cType.toComplexType(allWildcards), x.toComplexType(allWildcards));
      }
      
      return contextInstances.some(isInstanceOfTypeClass);
    }
    
    var tcInContextFound = classTypeToSearch.flatMap(findTypeClassInContextInstances);
    
    return switch (tcInContextFound) 
    {
      // the type class is passed as a context parameter
      case Some(x): Right(x._2);
      // we need to resolve the type class based on registry and using scope
      case None:
        function error () return ResolveError.InvalidTypeClass(tcType);
        var ct = tcType.asClassType();
        ct.toRight(error).flatMapRight(findTypeClassInRegistry);
    }
  }
  
  public static function makeInstanceExpr (info:TypeClassInstanceInfo, mapping:Mapping, contextClasses:Array<Tup2<Type, Expr>>,level:Int):Either<ResolveError, Expr> 
  {
    var deps = info.dependencies;
    
    var callTypes = {
      function remapDependency (x) return Utils.remap(x._1, mapping);
      function resolveDependency(x) return switch (x) 
      {
        case TInst(t, params):
          resolve(params[0], x, contextClasses, level+1);
        default: Scuts.unexpected();
      };
      deps.map(remapDependency).map(resolveDependency);
    }
    
    var callExprs = {
      function foldArgs (acc:Tup2<Array<ResolveError>, Array<Expr>>, c) return switch c 
      {
        case Left(l):  
          var errors = acc._1.appendElem(l);
          Tup2.create(errors, acc._2);
        case Right(r): 
          var exprs = acc._2.appendElem(r);
          Tup2.create(acc._1, exprs);
      }
      callTypes.foldLeft(foldArgs, Tup2.create([], []));
    }

    return 
      if (callExprs._1.length > 0) // no dependency found
        Left(DependencyErrors(callExprs._1)) 
      else 
      {
        // all dependencies found
        var pack = info.instance.pack;
        var module = SType.getModule(info.instance);
        var name = info.instance.name;
        var exprs = callExprs._2;
        Right(Make.type(pack, name, module).field("get").call(exprs));
      }
  }
  
  /**
   * Checks if a Type Class Instance is in using Scope. This is the case if the user
   * has included a "using" statement for the type class in the current module.
   * 
   * @param	instanceInfo
   */
  public static function isInstanceInUsingScope (instanceInfo:TypeClassInstanceInfo) 
  {
    var callField = instanceInfo.usingCall;
    var doCall = 
      Make.type(["hots", "macros", "internal"], "UsingScope")
      .field(callField)
      .call([]);
    return MContext.typeof(doCall).isSome();
  }

  
  
}

#end
  