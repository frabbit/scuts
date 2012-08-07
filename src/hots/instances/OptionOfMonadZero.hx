package hots.instances;

import hots.classes.MonadZeroAbstract;
import hots.In;
import scuts.core.types.Option;


using hots.box.OptionBox;

class OptionOfMonadZero extends MonadZeroAbstract<Option<In>>
{
  public function new () super(OptionOfMonad.get())
  
  override public inline function zero <A>():OptionOf<A> 
  {
    return None.box();
  }
  
}
