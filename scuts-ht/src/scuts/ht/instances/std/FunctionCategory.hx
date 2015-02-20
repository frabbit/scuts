package scuts.ht.instances.std;

import scuts.ht.classes.CategoryAbstract;
import scuts.ht.instances.std.Function;

using scuts.core.Functions;

private typedef F<A,B> = Function<In,In>;

class FunctionCategory extends CategoryAbstract<F<In,In>>
{

  public function new() {}

  override public function id <A>(a:A):F<A, A>
  {
    return new F(function (a) return a);
  }
  /**
   * aka (.)
   */
  override public function dot <A,B,C>(f:F<B, C>, g:F<A, B>):F<A, C>
  {
    return new F(f.run().compose(g.run()));
  }

}
