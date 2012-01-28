package scuts;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;

using scuts.core.extensions.DynamicExt;
#end

class Scuts 
{
  
  public static function id <T> (a:T):T return a
  
  public static function abstractMethod <T>():T {
    throw "This method is abstract, you must override it";
    return null;
  }
  
  public static function error <T>(msg:String):T 
  {
    throw msg;
    return null;
  }
  
  #if macro
  public static function macroError <T>(msg:String, ?p:Position):T 
  {
    var p1 = p.getOrElseNoMacro(Context.currentPos());
    throw new Error(msg,p1);
    return null;
  }
  #end
  
}