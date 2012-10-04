package hots.instances;

import hots.classes.MonadZeroAbstract;
import hots.In;
import hots.of.ArrayOf;

class ArrayMonadZero extends MonadZeroAbstract<Array<In>>
{
  public function new (monad) super(monad)
  
  override public inline function zero <A>():ArrayOf<A> 
  {
    return [];
  }
  
}
