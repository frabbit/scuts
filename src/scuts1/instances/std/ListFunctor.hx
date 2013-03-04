package scuts1.instances.std;

import scuts1.classes.Functor;
import scuts1.core.In;
import scuts1.instances.std.ListOf;
import scuts.core.Lists;


class ListFunctor implements Functor<List<In>>
{
  public function new () {}
  
  public function map<B,C>(x:ListOf<B>, f:B->C):ListOf<C> 
  {
    return Lists.map(x, f);
  }
}