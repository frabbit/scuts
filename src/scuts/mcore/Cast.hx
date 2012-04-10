package scuts.mcore;

#if (!macro && !display)
#error "Class can only be used inside of macros"
#elseif (display || macro)

import haxe.macro.Type;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.Timer;
import neko.FileSystem;
import neko.io.File;
import scuts.core.Log;

using scuts.mcore.extensions.ExprExt;
using scuts.mcore.extensions.StringExt;
using scuts.core.extensions.ArrayExt;


class Cast 
{
  
  public static function unsafeCastToComplexType (expr:Expr, type:ComplexType, ?pos:Position):Expr
  {
    var f = Make.funcExpr([Make.funcArg("x", false, TPath(Make.typePath([], "Dynamic")))], type, "x".asConstIdent().asReturn());
    return Make.call(f, [expr]);
  }
  
  public static function unsafeCastFromTo (expr:Expr, fromType:Type, toType:Type, wildcards:Array<Type>, ?pos:Position):Expr
  {
     return makeCastFromTo(expr, fromType, toType, wildcards, false, pos);
  }
  
  public static function safeCastFromTo (expr:Expr, fromType:Type, toType:Type, wildcards:Array<Type>, ?pos:Position):Expr
  {
    return makeCastFromTo(expr, fromType, toType, wildcards, true, pos);
  }
  
  
  /**
   * Returns an expression that performs an cast on {expr} from {fromType} to {toType}. 
   * This functions generates a new extern Class with a unique name based on it's parameters. The class contains 
   * one function doCast which performs an inlined cast (a no-op operation). After generation an expression 
   * is returned that calls the doCast function with expr as argument. 
   * The argument safe controls the type of cast, safe or unsafe cast (not checked by compiler).
   * 
   * @param	expr the expression to cast
   * @param	fromType the type from which to cast (must be compatible with the type of expr)
   * @param	toType the resulting type for the expression
   * @param	wildcards an array with wildcards which are used as function type parameters for generation of the doCast function.
   * @param safe Controls the type of cast, safe or unsafe.
   * @param	?pos an optional position for the generated expression
   * @return an expression that performs an unsafe cast.
   */
  static function makeCastFromTo (expr:Expr, fromType:Type, toType:Type, wildcards:Array<Type>, safe:Bool, pos:Position):Expr 
  {
    var id = Context.signature( [Print.type(toType), Print.type(fromType), wildcards.map(function (x) return Print.type(x))] );
    
    var clName = "TypedCast__" + (safe ? "safe" : "unsafe") + "__" + id;

    if (!FileSystem.exists(MContext.getCacheFolder() + "/" + clName + ".hx")) 
    {
      var fromTypeStr = Print.type(fromType, true, wildcards);
      var ct = Print.type(toType, true, wildcards);

      var wildcardsStr = "<" + Constants.UNKNOWN_T_MONO
        + (wildcards.length > 0 ? "," + wildcards.map(function (x) return Print.type(x, true, [x])).join(",") : "")
        + ">";
      
      var cl = "extern class " + clName + "\n{\n\tpublic static inline function doCast " + wildcardsStr + "(e:" + fromTypeStr + "):" + ct + " return " + (safe ? "" : "cast ") + "e\n}";
      var out = File.write(MContext.getCacheFolder() + "/" + clName + ".hx", false);
      out.writeString(cl);
      out.close();
    }
    
    var field = Make.field(Make.const(CType(clName), pos), "doCast", pos);
    var call = Make.expr(ECall(field, [expr]), pos);

    return call;
  }
  
}


#end