package scuts.ht.instances.std;

import scuts.ht.classes.Functor;
import scuts.ht.core._;
import scuts.ht.instances.std.ListOf;
import scuts.core.Lists;


class ListFunctor implements Functor<List<_>>
{
  public function new () {}

  public function map<B,C>(x:ListOf<B>, f:B->C):ListOf<C>
  {
    return Lists.map(x, f);
  }
}