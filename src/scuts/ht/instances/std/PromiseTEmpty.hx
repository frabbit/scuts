package scuts.ht.instances.std;

import scuts.ht.classes.Empty;
import scuts.ht.core.In;
import scuts.ht.instances.std.PromiseTOf;
import scuts.core.Promises;


import scuts.ht.core.Of;

import scuts.ht.classes.Monad;



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

