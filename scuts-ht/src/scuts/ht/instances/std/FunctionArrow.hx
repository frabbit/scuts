package scuts.ht.instances.std;

import scuts.ht.classes.ArrowAbstract;
import scuts.core.Tuples;
import scuts.ht.instances.std.FunctionCategory;
import scuts.ht.instances.std.Function;
using scuts.core.Functions;



private typedef F<A,B> = Function<A,B>;

// Arrow of Functions
class FunctionArrow extends ArrowAbstract<F<_,_>>
{
  public function new (cat) super(cat);

  /**
   * @inheritDoc
   */
  override public inline function arr <B,C>(f:B->C):F<B,C>
  {
    return new F(f);
  }
  /**
   * the first function
   */
  override public function first <B,C,D>(f:F<B,C>):F<Tup2<B,D>, Tup2<C,D>>
  {
    return arr(function (t:Tup2<B,D>) return Tup2.create(f(t._1), t._2));
  }

}
