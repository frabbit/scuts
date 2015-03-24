package scuts.ht.instances.std;

import scuts.ht.classes.Functor;
import scuts.core.Lists;


class ListFunctor implements Functor<List<_>>
{
  public function new () {}

  public function map<B,C>(x:List<B>, f:B->C):List<C>
  {
    return Lists.map(x, f);
  }
}