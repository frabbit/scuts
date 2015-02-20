package scuts.ht.instances.std;

import scuts.ht.classes.Functor;
import scuts.core.Arrays;


class ArrayFunctor implements Functor<Array<In>>
{
  public function new () {}

  public function map<B,C>(x:Array<B>, f:B->C):Array<C>
  {
    return Arrays.map(x, f);
  }
}