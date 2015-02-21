package scuts.ht.instances.std;

import scuts.ht.classes.Functor;
import scuts.ds.LazyLists;

class LazyListFunctor implements Functor<LazyList<_>>
{
  public function new () {}

  public function map<B,C>(of:LazyList<B>, f:B->C):LazyList<C> {
    return LazyLists.map(of, f);
  }
}