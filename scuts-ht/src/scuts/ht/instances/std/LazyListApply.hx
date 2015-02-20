package scuts.ht.instances.std;

import scuts.ht.classes.Apply;
import scuts.ht.classes.ApplyAbstract;

import scuts.ds.LazyLists;

class LazyListApply extends  ApplyAbstract<LazyList<In>>
{
  public function new (func) {
  	super(func);
  }

  override public function apply<B,C>(v:LazyList<B>, f:LazyList<B->C>):LazyList<C>
  {
    return LazyLists.flatMap(f, function (f1)
    {
      return LazyLists.map(v, function (x) return f1(x));
    });
  }
}
