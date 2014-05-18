package scuts.macros;
#if false
#if macro
import haxe.macro.Expr;
import scuts.macros.builder.PartialApplication;
import scuts.mcore.Select;
using scuts.core.Options;
#end

class F 
{
  /*
   * partial application
   * 
   * Examples:
   * 
   * var f1 = function (x:Int) return x;
   * var f2 = function (x:Int, y:Int) return x + y;
   * var f3 = function (x:Int, y:Int, z:Int) return x + y + z;
   * 
   * F._(f1(_)) => function (x) return f1(x)
   * F._(f2(1,_)) => function (y) return f2(1,y)
   * F._(f3(1,_,3)) => function (y) return f3(1,y,3)
   * F._(f3(_,_,3)) => function (x,y) return f3(x,y,3)
   * 
   * with using support (not available in macros)
   * 
   * 
   */
  macro public static function partial(expr:Expr) 
  {
    return Select.selectECall(expr)
      .map(function (x) return [x._1].concat(x._2))
      .map(function (x) return PartialApplication.apply(x))
      .getOrError("Expr must be a function call");
  }
  
  
}
#end