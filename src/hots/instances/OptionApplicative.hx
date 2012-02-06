package hots.instances;

import hots.classes.ApplicativeAbstract;
import hots.In;
import scuts.core.extensions.OptionExt;

import hots.classes.Applicative;
import scuts.core.types.Option;


using hots.instances.OptionBox;

class OptionApplicative
{
  static var instance;
  
  public static function get ()
  {
    if (instance == null) instance = new OptionApplicativeImpl();
    return instance;
  }
}

private class OptionApplicativeImpl extends ApplicativeAbstract<Option<In>>
{
  public function new () {
    super(OptionFunctor.get());
  }
  
  override public inline function ret<B>(b:B):OptionOf<B> 
  {
    return Some(b).box();
  }
  
  override public function apply<B,C>(f:OptionOf<B->C>, val:OptionOf<B>):OptionOf<C> 
  {
    return switch(f.unbox()) {
      case Some(f1): functor.map(f1, val);
      case None: None.box();
    }
  }
}