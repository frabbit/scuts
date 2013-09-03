package scuts.ht.instances.std;

import scuts.ht.classes.Apply;
import scuts.ht.classes.ApplyAbstract;
import scuts.ht.core.In;
import scuts.ht.instances.std.OptionOf;

import scuts.core.Options;



class OptionApply extends ApplyAbstract<Option<In>>
{
  public function new (func) {
  	super(func);
  }
  
  override public function apply<B,C>(x:OptionOf<B>, f:OptionOf<B->C>):OptionOf<C> return apply1(x, f);

  private function apply1 <B,C>(x:Option<B>, f:Option<B->C>):Option<C> return switch(f) 
  {
    case Some(f1): Options.map(x, f1);
    case None: None;
  }
  
}
