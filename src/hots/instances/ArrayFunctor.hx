package hots.instances;

import hots.classes.FunctorAbstract;
import hots.In;
import hots.of.ArrayOf;
import scuts.core.extensions.Arrays;


class ArrayFunctor extends FunctorAbstract<Array<In>>
{
  public function new () {}
  
  override public function map<B,C>(x:ArrayOf<B>, f:B->C):ArrayOf<C> 
  {
    return Arrays.map(x, f);
  }
}