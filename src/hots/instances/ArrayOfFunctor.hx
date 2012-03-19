package hots.instances;

import hots.classes.FunctorAbstract;
import hots.In;
import scuts.core.extensions.ArrayExt;
import hots.classes.Functor;

using hots.instances.ArrayBox;

class ArrayOfFunctor extends FunctorAbstract<Array<In>>
{
  public function new () {}
  
  override public function map<B,C>(f:B->C, fa:ArrayOf<B>):ArrayOf<C> {
    return ArrayExt.map(fa.unbox(), f).box();
  }
}