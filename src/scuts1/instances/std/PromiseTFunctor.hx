package scuts1.instances.std;

import scuts1.classes.Functor;

import scuts1.core.In;
import scuts1.core.Of;
import scuts1.instances.std.PromiseTOf;

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
