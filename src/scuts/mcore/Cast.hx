package scuts.mcore;

#if (!macro && !display)
#error "Class can only be used inside of macros"
#elseif (display || macro)

import haxe.macro.Context;
import haxe.macro.Expr;
import neko.FileSystem;
import neko.io.File;

using scuts.mcore.extensions.ExprExt;
using scuts.mcore.extensions.StringExt;

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
    var cl = "class " + clName + " { public static inline function doCast (e:Dynamic):" + ct + " return cast e }";
    var out = File.write(clName + ".hx", false);
    out.writeString(cl);
    out.close();
    Context.getType(clName);
    FileSystem.deleteFile(clName + ".hx");
    
    var field = Make.field(Make.const(CType(clName), pos), "doCast", pos);
    var call = Make.expr(ECall(field, [expr]), pos);
    return call;
  }
  
}


#end