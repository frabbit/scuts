package hots.instances;

import hots.classes.MonadZeroAbstract;
import hots.In;
import hots.Of;
import scuts.core.types.Option;
import hots.classes.Monad;

private typedef BT = OptionTBox;

class OptionTOfMonadZeroImpl<M> extends MonadZeroAbstract<Of<M, Option<In>>> {
  
  var monadM:Monad<M>;
  
  public function new (monadM:Monad<M>) {
    super(OptionTOfMonad.get(monadM));
    this.monadM = monadM;
  }
  
  override public inline function zero <A>():OptionTOf<M,A> {
    return BT.box(monadM.pure(None));
  }
}

typedef OptionTOfMonadZero = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(OptionTOfMonadZeroImpl)]>;