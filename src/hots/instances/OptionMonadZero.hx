package hots.instances;

import hots.classes.MonadZeroAbstract;
import hots.In;
import hots.of.OptionOf;
import scuts.core.types.Option;


class OptionMonadZero extends MonadZeroAbstract<Option<In>>
{
  public function new (mon) super(mon)
  
  override public inline function zero <A>():OptionOf<A> 
  {
    return None;
  }
  
}
