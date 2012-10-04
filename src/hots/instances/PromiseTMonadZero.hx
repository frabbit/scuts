package hots.instances;

import hots.classes.MonadZeroAbstract;
import hots.In;
import hots.instances.PromiseTMonad;
import hots.of.PromiseTOf;
import scuts.core.extensions.Promises;
import scuts.core.types.Promise;

import hots.Of;

import hots.classes.Monad;

using hots.Identity;
using hots.ImplicitCasts;

class PromiseTMonadZero<M> extends MonadZeroAbstract<Of<M, Promise<In>>> 
{
  
  var monadM:Monad<M>;
  
  public function new (monadM:Monad<M>, monad:PromiseTMonad<M>) {
    super(monad);
    this.monadM = monadM;
  }
  
  override public inline function zero <A>():PromiseTOf<M,A> 
  {
    return monadM.pure(Promises.cancelled());
  }
}

