package hots.instances;

import hots.classes.Empty;
import hots.In;
import hots.of.PromiseTOf;
import scuts.core.extensions.Promises;
import scuts.core.types.Promise;

import hots.Of;

import hots.classes.Monad;

using hots.Identity;
using hots.ImplicitCasts;

class PromiseTEmpty<M> implements Empty<Of<M, Promise<In>>> 
{
  var monadM:Monad<M>;
  
  public function new (monadM:Monad<M>) {
    this.monadM = monadM;
  }
  
  public inline function empty <A>():PromiseTOf<M,A> 
  {
    return monadM.pure(Promises.cancelled());
  }
}

