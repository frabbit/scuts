package scuts1.instances.std;

import scuts1.classes.Empty;
import scuts1.core.In;
import scuts1.instances.std.PromiseTOf;
import scuts.core.Promises;
import scuts.core.Promise;

import scuts1.core.Of;

import scuts1.classes.Monad;



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

