package hots.instances;

import hots.classes.Monad;
import hots.classes.MonadZeroAbstract;
import hots.Implicit;
import hots.In;
import hots.Objects;



using hots.box.ArrayBox;

class ArrayOfMonadZero extends MonadZeroAbstract<Array<In>>
{
  public function new (monad) super(monad)
  
  override public inline function zero <A>():ArrayOf<A> 
  {
    return [].box();
  }
  
}
