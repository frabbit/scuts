package hots.instances;

import hots.In;
import hots.of.LazyListOf;
import hots.classes.Functor;
import scuts.core.LazyLists;
import scuts.core.LazyList;



class LazyListFunctor implements Functor<LazyList<In>>
{
  public function new () {}
  
  public function map<B,C>(of:LazyListOf<B>, f:B->C):LazyListOf<C> {
    return LazyLists.map(of, f);
  }
}