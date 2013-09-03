package scuts.ht.instances.std;

import scuts.ht.core.In;
import scuts.ht.instances.std.LazyListOf;
import scuts.ht.classes.Functor;
import scuts.ds.LazyLists;



class LazyListFunctor implements Functor<LazyList<In>>
{
  public function new () {}
  
  public function map<B,C>(of:LazyListOf<B>, f:B->C):LazyListOf<C> {
    return LazyLists.map(of, f);
  }
}