package scuts.ht.instances.std;

import scuts.ht.classes.Apply;
import scuts.ht.core.In;
import scuts.ht.instances.std.OptionOf;

import scuts.core.Options;



class OptionApply implements Apply<Option<In>>
{
  public function new () {}
  
  public function apply<B,C>(f:OptionOf<B->C>, x:OptionOf<B>):OptionOf<C> return apply1(f,x);

  private function apply1 <B,C>(f:Option<B->C>, x:Option<B>):Option<C> return switch(f) 
  {
    case Some(f1): Options.map(x, f1);
    case None: None;
  }
  
}
