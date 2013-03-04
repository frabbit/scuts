package scuts1.instances.std;
import scuts1.core.In;
import scuts1.classes.ArrowAbstract;
import scuts1.instances.std.ContOfOf;
import scuts1.instances.std.FunctionOfOf;
import scuts.core.Cont;
import scuts.core.Conts;
import scuts.core.Tup2;
import scuts1.instances.std.FunctionCategory;
using scuts.core.Functions;


 
// Arrow of Functions
class ContArrow<R> extends ArrowAbstract<In -> Cont<In, R>>
{
  public function new (cat) super(cat);
  
  /**
   * @inheritDoc
   */
  override public inline function arr <B,C>(f:B->C):ContOfOf<R, B, C> 
  {
    return function (a:B):Cont<C,R> {
      return function (c:C->R) return c(f(a));
    };
  }
  /**
   * the first function
   */
  override public function first <B,C,D>(f:ContOfOf<R,B,C>):ContOfOf<R, Tup2<B,D>, Tup2<C,D>> 
  {
    return _first(f);
  }
  
  private static function _first <R, B,C,D>(f:B->Cont<C, R>):Tup2<B,D> -> Cont<Tup2<C,D>, R> 
  {
    return function (x:Tup2<B,D>) {
      return Conts.map(f(x._1), function (c:C) return Tup2.create(c, x._2));
    }
  }
}
