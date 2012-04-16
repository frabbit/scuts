package hots.instances;

import hots.classes.PointedAbstract;
import hots.In;
import scuts.core.extensions.Options;
import scuts.core.types.Option;

using hots.box.OptionBox;

class OptionOfPointed extends PointedAbstract<Option<In>>
{
  public function new () {
    super(OptionOfFunctor.get());
  }
  
  override public inline function pure<B>(b:B):OptionOf<B> 
  {
    return Some(b).box();
  }
  
}
