package scuts.mcore;

#if (!macro && !display)
#error "Class can only be used inside of macros"
#elseif (display || macro)

import haxe.macro.Type;
import haxe.macro.Context;
import haxe.macro.Expr;
import neko.FileSystem;
import neko.io.File;
import scuts.core.Log;

using scuts.mcore.extensions.ExprExt;
using scuts.mcore.extensions.StringExt;
using scuts.core.extensions.ArrayExt;


class Cast 
{
  
  public static function unsafeCastTo (expr:Expr, type:ComplexType, ?pos:Position):Expr
  {
    var f = Make.funcExpr([Make.funcArg("x", false, TPath(Make.typePath([], "Dynamic")))], type, "x".asConstIdent().asReturn());
    return Make.call(f, [expr]);
  }
  
  public static function inlinedUnsafeCastTo (expr:Expr, type:ComplexType, ?pos:Position):Expr
  {
    var id = Context.signature(type);
    var clName = "TypedCast__" + id;
    var ct = Print.complexType(type);
    var cl = "extern class " + clName + " { public static inline function doCast (e:Dynamic):" + ct + " return cast e }";
    var out = File.write(clName + ".hx", false);
    out.writeString(cl);
    out.close();
    Context.getType(clName);
    FileSystem.deleteFile(clName + ".hx");
    
    var field = Make.field(Make.const(CType(clName), pos), "doCast", pos);
    var call = Make.expr(ECall(field, [expr]), pos);
    return call;
  }
  public static function inlinedUnsafeCastTo2 (expr:Expr, fromType:Type, toType:Type, wildcards:Array<Type>, ?pos:Position):Expr
  {
    //var fromType = Print.type(Context.typeof(expr), true, wildcards);
    var id = Context.signature([toType, fromType, wildcards]);
    
    
    
    
    var clName = "TypedCast__" + id;

    if (!FileSystem.exists(MContext.getCacheFolder() + "/" + clName + ".hx")) {
    
      
      var fromTypeStr = Print.type(Context.typeof(expr), true, wildcards);
      var ct = Print.type(toType, true, wildcards);

      var wildcardsStr = "<" + Constants.UNKNOWN_T_MONO
        + (wildcards.length > 0 ? "," + wildcards.map(function (x) return Print.type(x, true, [x])).join(",") : "")
        + ">";
      
      Log.debugObj(null,wildcardsStr);
      var cl = "extern class " + clName + " { public static inline function doCast " + wildcardsStr + "(e:" + fromTypeStr + "):" + ct + " return cast e }";
      var out = File.write(MContext.getCacheFolder() + "/" + clName + ".hx", false);
      out.writeString(cl);
      out.close();
      
      Context.getType(clName);
      //FileSystem.deleteFile(clName + ".hx");
    } else {
      
      Context.getType(clName);
    }
    
    var field = Make.field(Make.const(CType(clName), pos), "doCast", pos);
    var call = Make.expr(ECall(field, [expr]), pos);

    return call;
  }
  
}


#end