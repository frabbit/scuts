package hots.instances;

import hots.classes.MonadZeroAbstract;
import hots.In;
import hots.Of;
import scuts.core.types.Option;
import hots.classes.Monad;

private typedef BT = OptionTBox;

class OptionTOfMonadZeroImpl<M> extends MonadZeroAbstract<Of<M, Option<In>>> {
  
  var monad:Monad<M>;
  
  public function new (monad:Monad<M>) {
    super(OptionTOfMonad.get(monad));
    this.monad = monad;
  }
  
  override public inline function zero <A>():OptionTOf<M,A> {
    return BT.box(monad.ret(None));
  }
}

typedef OptionTOfMonadZero = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(OptionTOfMonadZeroImpl)]>;