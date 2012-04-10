package hots.instances;

import hots.classes.ApplicativeAbstract;
import hots.In;
import scuts.core.extensions.OptionExt;
import scuts.core.types.Option;

using hots.box.OptionBox;

class OptionOfApplicative extends ApplicativeAbstract<Option<In>>
{
  public function new () {
    super(OptionOfPointed.get());
  }
  
  override public function apply<B,C>(f:OptionOf<B->C>, of:OptionOf<B>):OptionOf<C> 
  {
    return switch(f.unbox()) {
      case Some(f1): map(of, f1);
      case None: None.box();
    }
  }
}
