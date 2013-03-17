package scuts.ht.instances.std;

import scuts.ht.classes.Functor;
import scuts.ht.core.In;
import scuts.ht.instances.std.ArrayOf;
import scuts.core.Arrays;


class ArrayFunctor implements Functor<Array<In>>
{
  public function new () {}
  
  public function map<B,C>(x:ArrayOf<B>, f:B->C):ArrayOf<C> 
  {
    return Arrays.map(x, f);
  }
}