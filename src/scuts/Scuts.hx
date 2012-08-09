package scuts;

import haxe.PosInfos;
import haxe.Stack;
import scuts.core.extensions.PosInfosTools;

using scuts.core.extensions.Arrays;
using scuts.core.extensions.Strings;
#if macro
import haxe.macro.Context;
import haxe.macro.Expr;

using scuts.core.extensions.Dynamics;
using scuts.core.extensions.PosInfosTools;
#end

class Scuts 
{
  
  public static function id <T> (a:T):T return a
  
  public static function posInfos <T>(?p:PosInfos):PosInfos return p
  
  public static function abstractMethod <T>():T 
  {
    return error("Scuts.abstract: This method is abstract, you must override it");
  }
  
  public static function notImplemented <T>(?posInfos:PosInfos):T 
  {
    return error("Scuts.notImplemented: This method is not yet implemented", posInfos);
  }
  
  public static function unexpected <T>(?posInfos:PosInfos):T 
  {
    return error("Scuts.unexpected: This error shoud never occur, please inform the library author to fix this.", posInfos);
  }
  
  public static function checkNotNull <T>(v:T, ?posInfos:PosInfos):T 
  {
    #if debug
    Assert.notNull(v, posInfos);
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
  #if macro
  public static function warning <T>(headline:String, msg:Dynamic, ?p:Position):T 
  {
    var p1 = p.nullGetOrElseConst(Context.currentPos());
   
    Context.warning(headline + "\n" + msg, p1);
    return null;
  }
  #end
  
  
  #if macro
  

  public static function macroError <T>(msg:String, ?p:Position, ?posInfos:PosInfos):T 
  {
    var p1 = p.nullGetOrElseConst(Context.currentPos());
    #if scutsDebug
    var stack = 
      Stack.toString(Stack.callStack())
      .trim().split("\n")
      .reverseCopy()
      .filter(function (x) return x.indexOf("scuts/Scuts.hx") == -1 && x.indexOf("haxe/Stack.hx") == -1)
      .join("\n");
    
    new Error
    (
      msg + "\n@" + posInfos.toString() 
      + "\n-----------------------------------------------------------------------------\n" 
      + stack 
      + "\n-----------------------------------------------------------------------------",p1
    );
    #else
    throw new Error(msg, p1);
    #end
    return null;
  }
  
  public static function macroErrors <T>(msg:Array<String>, ?p:Position, ?posInfos:PosInfos):T 
  {
    return macroError(msg.join("\n"), p, posInfos);
  }
  
 
  #end
  
}