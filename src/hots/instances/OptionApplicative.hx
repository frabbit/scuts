package hots.instances;

import hots.classes.ApplicativeAbstract;
import hots.In;
import hots.of.OptionOf;
import scuts.core.extensions.Options;
import scuts.core.types.Option;

using hots.box.OptionBox;

class OptionApplicative extends ApplicativeAbstract<Option<In>>
{
  public function new (pure, functor) 
  {
    super(pure, functor);
  }
  
  override public function apply<B,C>(f:OptionOf<B->C>, x:OptionOf<B>):OptionOf<C> return apply1(f,x)

  private function apply1 <B,C>(f:Option<B->C>, x:Option<B>):Option<C> return switch(f) 
  {
    case Some(f1): Options.map(x, f1);
    case None: None;
  }
  
}
