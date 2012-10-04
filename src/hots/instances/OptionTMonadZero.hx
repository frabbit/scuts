package hots.instances;

import hots.classes.MonadZeroAbstract;
import hots.In;
import hots.of.OptionTOf;

import hots.Of;
import scuts.core.types.Option;
import hots.classes.Monad;

using hots.Identity;
using hots.ImplicitCasts;

class OptionTMonadZero<M> extends MonadZeroAbstract<Of<M, Option<In>>> {
  
  var monadM:Monad<M>;
  
  public function new (monadM:Monad<M>, monad:OptionTMonad<M>) {
    super(monad);
    this.monadM = monadM;
  }
  
  override public inline function zero <A>():OptionTOf<M,A> 
  {
    return monadM.pure(None);
  }
}

