package hots.instances;

import hots.classes.MonadZeroAbstract;
import hots.In;
import scuts.core.types.Option;


using hots.instances.OptionBox;


class OptionOfMonadZeroImpl extends MonadZeroAbstract<Option<In>>
{
  public function new () super(OptionOfMonad.get())
  
  override public inline function zero <A>():OptionOf<A> {
    return None.box();
  }
  
}

typedef OptionOfMonadZero = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(OptionOfMonadZeroImpl)]>;