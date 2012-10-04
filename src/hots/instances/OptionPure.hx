package hots.instances;

import hots.classes.PureAbstract;
import hots.In;
import hots.of.OptionOf;
import scuts.core.extensions.Options;
import scuts.core.types.Option;

using hots.box.OptionBox;

class OptionPure extends PureAbstract<Option<In>>
{
  public function new () {}
  
  override public inline function pure<B>(b:B):OptionOf<B> 
  {
    return Options.pure(b);
  }
  
}
