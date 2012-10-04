package hots.instances;

import hots.classes.MonadZeroAbstract;
import hots.In;
import hots.of.PromiseOf;
import scuts.core.extensions.Promises;


import scuts.core.types.Promise;


class PromiseMonadZero extends MonadZeroAbstract<Promise<In>>
{
  public function new (mon) super(mon)
  
  override public inline function zero <A>():PromiseOf<A> 
  {
    return Promises.cancelled();
  }
  
}
