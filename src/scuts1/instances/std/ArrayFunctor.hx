package scuts1.instances.std;

import scuts1.classes.Functor;
import scuts1.core.In;
import scuts1.instances.std.ArrayOf;
import scuts.core.Arrays;


class ArrayFunctor implements Functor<Array<In>>
{
  public function new () {}
  
  public function map<B,C>(x:ArrayOf<B>, f:B->C):ArrayOf<C> 
  {
    return Arrays.map(x, f);
  }
}