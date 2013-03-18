package scuts.ht.instances.std;

import scuts.core.Lazy;
import scuts.ht.classes.Functor;
import scuts.ht.core.In;
import scuts.ht.instances.std.ArrayOf;
import scuts.core.Arrays;
import scuts.ht.instances.std.LazyOf;


class LazyFunctor implements Functor<Lazy<In>>
{
  public function new () {}
  
  public function map<B,C>(x:LazyOf<B>, f:B->C):LazyOf<C> 
  {
  	var x1 : Void -> B = x;
    return function () return f(x1());
  }
}