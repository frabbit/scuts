package hots.instances;

import hots.classes.ApplicativeAbstract;
import hots.In;
import scuts.core.extensions.OptionExt;
import scuts.core.types.Option;

using hots.instances.OptionBox;

class OptionOfApplicativeImpl extends ApplicativeAbstract<Option<In>>
{
  public function new () {
    super(OptionOfFunctor.get());
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

typedef OptionOfApplicative = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(OptionOfApplicativeImpl)]>;