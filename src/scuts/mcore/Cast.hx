package scuts.mcore;

#if (!macro && !display)
#error "Class can only be used inside of macros"
#elseif (display || macro)

import haxe.macro.Context;
import haxe.macro.Expr;
import neko.FileSystem;
import neko.io.File;

class Cast 
{

  public static function typedCast (expr:Expr, type:ComplexType, ?pos:Position):Expr
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
    var call = Make.mkExpr(ECall(field, [expr]), pos);
    return call;
  }

}


#end