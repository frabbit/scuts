package hots.instances;

import hots.classes.FunctorAbstract;
import hots.In;
import hots.Of;
import scuts.core.extensions.Futures;
import scuts.core.types.Future;

using hots.box.FutureBox;

class FutureOfFunctor extends FunctorAbstract<Future<In>>
{
  public function new () {}
  
  override public function map<A,B>(of:FutureOf<A>, f:A->B):FutureOf<B> {
    return Futures.map(of.unbox(), f).box();
  }
}
