package scuts.macros.debug;
import haxe.macro.Expr;
import scuts.mcore.Make;
import scuts.mcore.MContext;
import scuts.mcore.Print;
using scuts.core.Options;
/**
 * ...
 * @author 
 */

class Debug 
{

  public static function printType(e:Expr) 
  {
    
    var t = MContext.typeof(e);
    t.map(function (x) Print.type(x, true, 
    Print.type(
    
    Make.emptyBlock();
  }
  
}