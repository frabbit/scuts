package scuts1.instances.std;

import scuts1.classes.Apply;
import scuts1.core.In;
import scuts1.instances.std.LazyListOf;

import scuts.ds.LazyLists;

class LazyListApply implements Apply<LazyList<In>>
{
  public function new () {}
  
  public function apply<B,C>(f:LazyListOf<B->C>, v:LazyListOf<B>):LazyListOf<C> 
  {
    return LazyLists.flatMap(f, function (f1) 
    {
      return LazyLists.map(v, function (x) return f1(x));
    });
  }
}
