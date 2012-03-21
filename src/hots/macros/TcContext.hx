package hots.macros;


#if !macro
import hots.TC;
#end
import hots.macros.utils.Utils;

import scuts.core.Log;
import scuts.core.types.Tup2;


import scuts.Scuts;



#if (macro || display)

import scuts.mcore.Parse;
import scuts.mcore.MContext;
import haxe.macro.Context;
import haxe.macro.Type;
import haxe.macro.Expr;
import scuts.mcore.Make;
import scuts.core.types.Option;
import scuts.mcore.Print;
using scuts.core.extensions.ArrayExt;
using scuts.core.extensions.OptionExt;
import hots.macros.TypeClasses;


using scuts.core.Log;
using scuts.mcore.extensions.TypeExt;
using scuts.mcore.extensions.ExprExt;
using scuts.core.extensions.StringExt;
private typedef SType = scuts.mcore.Type;

enum ResolveError {
  InvalidTypeClass(t:Type);
  NoInstanceFound(tcId:String, exprType:Type);
  MultipleInstancesNoneInScope(tcId:String, exprType:Type);
  MultipleInstancesWithScope(tcId:String, exprType:Type);
}

#end

class TcContext 
{

    
  
  
  @:macro public static function tc(expr:Expr, tc:ExprRequire<Class<TC>>) 
  {
    // expr can be a value or a type
    var exprType = Context.typeof(expr);
    var expr = switch (exprType) {
      case TType(t, p):
        var dt = t.get();
        if (dt.name.indexOf("#") == 0) 
        {
          if (dt.params.length > 0) 
          {
            Scuts.macroError("Types with parameters are not supported as first parameter.", expr.pos);
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
          expr;
        }
      default: expr;
    }

    var tcType = switch (Context.typeof(tc)) {
      case TType(dt, params):
        var p = dt.get().pack;
        Context.getType((p.length > 0 ? p.join(".") + "." : "") + dt.get().name.substr(1));
      default: Scuts.macroError("Invalid type");
    }
    return resolve(exprType, tcType);
  }
  
  #if (macro || display)
  
  public static function handleResolveError <T>(e:ResolveError):T 
  {
    var msg = switch (e) 
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
    }
    return Scuts.macroError(msg);
  }
  
  public static function resolve (exprType:Type, tcType:Type, level:Int = 0) 
  {
    var type = tcType.asClassType().getOrError("Invalid Type Class");
    
    var ct = type._1;
    
    var tcId = SType.getFullQualifiedTypeName(ct.get());
    [].debugObj("  ".times(level) + "resolve: " + tcId + " for " + Print.type(exprType));
    
    var info = TypeClasses.registry.get(tcId);
    
    var filtered = info.map(
      function (x) {
        return Tup2.create(x, Utils.typeIsCompatibleTo(exprType, x.tcParamTypes[0], x.allParameters));
      }
    ).filter(function (x) return x._2.isSome());
    
    
    
    return (switch (filtered.length) {
      case 0: 
        Utils.getOfContainerType(exprType)
        .map( function (x) return resolve(x, tcType, level+1))
        .getOrElse(function () return Scuts.macroError("Cannot find Type class Instance of " + tcId + " for type " + Print.type(exprType)));
      case 1: 
        var info = filtered[0]._1;
        
        var mapping = filtered[0]._2.extract();
        makeInstanceExpr(info, mapping, level);
        
        
        
      default: 
        // we've got multiple type classes, check if only one of them is in using scope
        var inScope = filtered.filter(function (x) return isInstanceInUsingScope(x._1));
        
        
        if (inScope.length == 0) 
        {
          Scuts.macroError("Cannot resolve Type Class " + tcId + " for type " + 
            Print.type(exprType) + ".\nMultiple type classes were found and none of them is in scope.");
        }
        else if (inScope.length > 1) 
        {
          Scuts.macroError("Cannot resolve Type Class " + tcId + " for type " + 
            Print.type(exprType) + ". Multiple type classes were found and more than one is in scope.");
        } 
        else 
        {
          var tc = inScope[0];
          makeInstanceExpr(tc._1, tc._2.extract(), level);
        }
    }).debug(function (x) return "  ".times(level) + "generated: " + Print.expr(x));
  }
  
  
  public static function makeInstanceExpr (info:TypeClassInstanceInfo, mapping:Mapping, level:Int):Expr {
   
    var deps = info.dependencies;
    
    var callArgs = 
      deps.map(function (x) return Utils.remap(x._1, mapping))
      .map(function (x) return switch (x) {
        case TInst(t, params):
          resolve(params[0], x, level+1);

        default: Scuts.unexpected();
      });
    
    var pack = info.instance.pack;
    var module = SType.getModule(info.instance);
    var name = info.instance.name;
    
    
    
    return Make.type(pack, name, module).field("get").call(callArgs);
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