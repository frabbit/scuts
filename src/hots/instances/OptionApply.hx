package hots.instances;

import hots.classes.Apply;
import hots.In;
import hots.of.OptionOf;
import scuts.core.Options;
import scuts.core.Option;

using hots.box.OptionBox;

class OptionApply implements Apply<Option<In>>
{
  public function new () {}
  
  public function apply<B,C>(f:OptionOf<B->C>, x:OptionOf<B>):OptionOf<C> return apply1(f,x)

  private function apply1 <B,C>(f:Option<B->C>, x:Option<B>):Option<C> return switch(f) 
  {
    case Some(f1): Options.map(x, f1);
    case None: None;
  }
  
}
