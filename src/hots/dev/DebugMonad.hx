package hots.dev;
import haxe.Log;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.PosInfos;
import scuts.macro.Make;
import scuts.macro.Print;

/**
 * ...
 * @author 
 */

class DebugMonad 
{

  @:macro public static function printType (m:Expr ) 
  {
    
    var toPrint = Print.typeStr(Context.follow(Context.typeof(m),false));
    
    toPrint = toPrint.split("__monadic_marker_dont_use_me_internal_1__").join("F1");
    toPrint = toPrint.split("__monadic_marker_dont_use_me_internal_2__").join("F2");
    
    toPrint = toPrint.split("hots.wrapper.").join("");
    
    trace(toPrint);
    
    return Make.mkEmptyBlock();
  }
  
  @:macro public static function printTypeLocal (m:Expr ) 
  {
    
    var toPrint = Print.typeStr(Context.typeof(m));
    
    trace(toPrint);
    
    return Make.mkEmptyBlock();
  }
  
}