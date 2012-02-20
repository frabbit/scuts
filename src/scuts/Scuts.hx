package scuts;

import haxe.PosInfos;
import scuts.core.extensions.PosInfosExt;

#if (macro || display)
import haxe.macro.Context;
import haxe.macro.Expr;

using scuts.core.extensions.DynamicExt;
using scuts.core.extensions.PosInfosExt;
#end

class Scuts 
{
  
  public static function id <T> (a:T):T return a
  
  public static function abstractMethod <T>():T {
    return error("This method is abstract, you must override it");
  }
  
  public static function notImplemented <T>(?posInfos:PosInfos):T {
    return error("This method is not yet implemented", posInfos);
  }
  
  public static function checkNotNull <T>(v:T):T {
    #if debug
    Assert.assertNotNull(v);
    #end
    return error("This method is not yet implemented");
  }
  
  public static function error <T>(msg:Dynamic, ?posInfos:PosInfos):T 
  {
    #if macro
    return macroError(Std.string(msg), Context.currentPos(), posInfos);
    #else
    throw msg;
    return null;
    #end
  }
  
  
  #if (macro || display)
  public static function macroError <T>(msg:String, ?p:Position, ?posInfos:PosInfos):T 
  {
    var p1 = p.getOrElse(Context.currentPos());
    throw new Error(posInfos.toString() + ": " + msg,p1);
    return null;
  }
  
 
  #end
  
}