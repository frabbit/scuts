package scuts.ht.instances.std;

import scuts.ht.classes.Functor;

import scuts.ht.core.In;
import scuts.ht.core.Of;
import scuts.ht.instances.std.PromiseTOf;

import scuts.core.Promises;








class PromiseTFunctor<M> implements Functor<Of<M, Promise<In>>> {
  
  var functorM:Functor<M>;
  
  public function new (functorM:Functor<M>) 
  {
    this.functorM = functorM;
  }

  public function map<A,B>(v:PromiseTOf<M, A>, f:A->B):PromiseTOf<M, B> 
  {

    return functorM.map(v, Promises.map.bind(_,f));
  }
}
