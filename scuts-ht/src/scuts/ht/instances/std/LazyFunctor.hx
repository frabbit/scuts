package scuts.ht.instances.std;

import scuts.core.Lazy;
import scuts.ht.classes.Functor;
import scuts.core.Arrays;



class LazyFunctor implements Functor<Lazy<_>>
{
  public function new () {}

  public function map<B,C>(x:Lazy<B>, f:B->C):Lazy<C>
  {

    return new Lazy(function () return f(x()));
  }
}