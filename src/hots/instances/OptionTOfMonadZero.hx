package hots.instances;

import hots.classes.MonadZeroAbstract;
import hots.In;

import hots.Of;
import scuts.core.types.Option;
import hots.classes.Monad;

using hots.box.OptionBox;

class OptionTOfMonadZero<M> extends MonadZeroAbstract<OfT<M, Option<In>>> {
  
  var monadM:Monad<M>;
  
  public function new (monadM:Monad<M>) {
    super(OptionTOfMonad.get(monadM));
    this.monadM = monadM;
  }
  
  override public inline function zero <A>():OptionTOf<M,A> 
  {
    return monadM.pure(None).boxT();
  }
}

