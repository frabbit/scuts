package scuts1.instances.std;

import scuts1.core.In;
import scuts1.instances.std.LazyListOf;
import scuts1.classes.Functor;
import scuts.ds.LazyLists;



class LazyListFunctor implements Functor<LazyList<In>>
{
  public function new () {}
  
  public function map<B,C>(of:LazyListOf<B>, f:B->C):LazyListOf<C> {
    return LazyLists.map(of, f);
  }
}