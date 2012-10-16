package hots.instances;

import hots.classes.Apply;
import hots.In;
import hots.of.LazyListOf;

import scuts.core.LazyList;
import scuts.core.LazyLists;

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
