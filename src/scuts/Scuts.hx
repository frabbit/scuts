package scuts;

import haxe.PosInfos;

#if (macro || display)
import haxe.macro.Context;
import haxe.macro.Expr;

using scuts.core.extensions.DynamicExt;
#end

class Scuts 
{
  
  public static function id <T> (a:T):T return a
  
  public static function abstractMethod <T>():T {
    return error("This method is abstract, you must override it");
  }
  
  public static function notImplemented <T>():T {
    return error("This method is not yet implemented");
  }
  
  public static function checkNotNull <T>(v:T):T {
    #if debug
    Assert.assertNotNull(v);
    #end
    return error("This method is not yet implemented");
  }
  
  public static function error <T>(msg:String, ?posInfos:PosInfos):T 
  {
    #if macro
    return macroError(msg, Context.currentPos(), posInfos);
    #else
    throw msg;
    return null;
    #end
  }
  
  
  #if macro
  public static function macroError <T>(msg:String, ?p:Position, ?posInfos:PosInfos):T 
  {
    var p1 = p.getOrElse(Context.currentPos());
    throw new Error(msg,p1);
    return null;
  }
  #end
  
}