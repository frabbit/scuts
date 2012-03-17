package hots.macros;


import hots.macros.utils.Utils;
import hots.TC;
import scuts.core.types.Tup2;


import scuts.Scuts;



#if (macro || display)
import scuts.mcore.Parse;
import scuts.mcore.ExtendedContext;
import haxe.macro.Context;
import haxe.macro.Type;
import haxe.macro.Expr;
import scuts.mcore.Make;
import scuts.core.types.Option;
import scuts.mcore.Print;
using scuts.core.extensions.ArrayExt;
using scuts.core.extensions.OptionExt;


using scuts.mcore.extensions.TypeExt;
using scuts.mcore.extensions.ExprExt;
private typedef SType = scuts.mcore.Type;

enum CheckAmbiguity {
  Using(cl:String);
  UsingOf(cl:String);
  No;
}

#end


class TcContext 
{

  #if (macro || display)
  private static function callTimes (expr:Expr, fn:String, params:Array<Expr>, times:Int) {
    for (i in 0...times) {
      expr = Make.call(Make.field(expr, fn), params, expr.pos);
    }
    return expr;
  }
  #end
  
  @:macro public static function box2(expr:Expr) {
    
    return try {
      var call = callTimes(expr, "box", [], 2);
      Context.typeof(call);
      call;
    } catch (e:Dynamic) {
      Scuts.macroError("Cannot box the expression " + Print.expr(expr) + " into an hots.Of 2 times");
    }
  }
  
  @:macro public static function box3(expr:Expr) {
    return try {
      var call = callTimes(expr, "box", [], 3);
      Context.typeof(call);
      call;
    } catch (e:Dynamic) {
      Scuts.macroError("Cannot box the expression " + Print.expr(expr) + " into an hots.Of 3 times");
    }
  }
  
  @:macro public static function boxF2(expr:Expr) {
    
    return try {
      var call = callTimes(expr, "boxF", [], 2);
      Context.typeof(call);
      call;
    } catch (e:Dynamic) {
      Scuts.macroError("Cannot box the expression " + Print.expr(expr) + " into an hots.Of 2 times");
    }
  }
  
  @:macro public static function boxF3(expr:Expr) {
    return try {
      var call = callTimes(expr, "boxF", [], 3);
      Context.typeof(call);
      call;
    } catch (e:Dynamic) {
      Scuts.macroError("Cannot box the expression " + Print.expr(expr) + " into an hots.Of 3 times");
    }
  }
  @:macro public static function unbox2<M,A,B>(expr:ExprRequire<hots.Of<hots.Of<M, B>,A>>) {
    return callTimes(expr, "unbox", [], 2);
  }
  
  @:macro public static function unbox3<M,A,B,C>(expr:ExprRequire<hots.Of<hots.Of<hots.Of<M,C>, B>,A>>) {
    return callTimes(expr, "unbox", [], 3);
  }
  
  @:macro public static function tc(expr:Expr, tc:ExprRequire<Class<TC>>) 
  {
    // expr can be a value or a type
    var exprType = Context.typeof(expr);
    var expr = switch (exprType) {
      case TType(t, p):
        var dt = t.get();
        if (dt.name.indexOf("#") != -1) 
        {
          if (dt.params.length > 0) 
          {
            Scuts.macroError("Types with parameters are not supported as first parameter.", expr.pos);
          } 
          else 
          {
            // make a complex type
            var ct = {
              var typePath = Make.typePath(dt.pack, dt.name.split("#").join(""),[]);
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
  public static function resolve (exprType:Type, tcType:Type) {
    var type = tcType.asClassType().getOrError("Invalid Type Class");
    
    var ct = type._1;
    
    var tcId = SType.getFullQualifiedTypeName(ct.get());
    
    var info = TypeClasses.registry.get(tcId);
    
    
    //trace(exprType);
    var filtered = info.map(
      function (x) {
        return Tup2.create(x, Utils.typeIsCompatibleTo(exprType, x.tcParamTypes[0], x.allParameters));
      }
    ).filter(function (x) return x._2.isSome());
    
    
    return switch (filtered.length) {
      case 0: Scuts.macroError("Cannot find Type class Instance of " + tcId + " for type " + Print.type(exprType));
      case 1: 
        var info = filtered[0]._1;
        
        var mapping = filtered[0]._2.extract();
        var deps = info.dependencies;
        
        var callArgs = 
          deps.map(function (x) return Utils.remap(x._1, mapping))
          .map(function (x) return switch (x) {
            case TInst(t, params):
              resolve(params[0], x);
            default: Scuts.error("Invalid");
          });
        
        var pack = info.instance.pack;
        var module = SType.getModule(info.instance);
        var name = info.instance.name;
        
        
        
        var e = Make.type(pack, name, module).field("get").call(callArgs);
        
        //var e = Make.type(Make.constIdent(first).fields(parts.drop(1).removeLast()), parts.last()).field("get").call(callArgs);
        
        trace(Print.expr(e));
        
        
        
        Make.emptyBlock();
        e;
        
      default: Scuts.macroError("Found multiple type classes, not yet possible.");
    }
    
  }
  #end
  /*
  public static function ofConstract (t:Type, once:Bool = true) {
    
  }
  
  
  
  public static function ofExpand (t:Type, once:Bool = true):Option<Type> {
    
    var ofType = switch (Context.getType("hots.Of")) {
      case Type.TAnonymous(ref): ref;
      default: Scuts.macroError("hots.Of not available");
    }
    switch (t) {
      case Type.TInst(t, params): 
        if (params.length > 0) {
          Type.TAnonymous(ofType);
        } else {
          None;
        }
    }
  }
  */
  
}