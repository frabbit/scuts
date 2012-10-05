package hots.instances;

import hots.classes.Functor;
import hots.In;
import hots.of.ArrayOf;
import scuts.core.extensions.Arrays;


class ArrayFunctor implements Functor<Array<In>>
{
  public function new () {}
  
  public function map<B,C>(x:ArrayOf<B>, f:B->C):ArrayOf<C> 
  {
    return Arrays.map(x, f);
  }
}