package hots.instances;

import hots.classes.ApplicativeAbstract;
import hots.In;
import hots.Objects;
import scuts.core.extensions.Options;
import scuts.core.types.Option;

using hots.box.OptionBox;

class OptionOfApplicative extends ApplicativeAbstract<Option<In>>
{
  public function new (pointed) 
  {
    super(pointed);
  }
  
  override public function apply<B,C>(f:OptionOf<B->C>, of:OptionOf<B>):OptionOf<C> return switch(f.unbox()) 
  {
    case Some(f1): map(of, f1);
    case None: None.box();
  }

}
