package scuts.ht.instances.std;

import scuts.ht.classes.Apply;
import scuts.ht.classes.ApplyAbstract;
import scuts.ht.core.In;
import scuts.ht.instances.std.LazyListOf;

import scuts.ds.LazyLists;

class LazyListApply extends  ApplyAbstract<LazyList<In>>
{
  public function new (func) {
  	super(func);
  }
  
  override public function apply<B,C>(v:LazyListOf<B>, f:LazyListOf<B->C>):LazyListOf<C> 
  {
    return LazyLists.flatMap(f, function (f1) 
    {
      return LazyLists.map(v, function (x) return f1(x));
    });
  }
}
