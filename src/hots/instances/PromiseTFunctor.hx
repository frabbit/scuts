package hots.instances;

import hots.classes.Functor;

import hots.In;
import hots.Of;
import hots.of.PromiseTOf;
import scuts.core.Promises;
import scuts.core.Promise;
import scuts.core.Tup2;

using hots.ImplicitCasts;
using hots.Hots;
using hots.Identity;

using hots.box.StateBox;

class PromiseTFunctor<M> implements Functor<Of<M, Promise<In>>> {
  
  var functorM:Functor<M>;
  
  public function new (functorM:Functor<M>) 
  {
    this.functorM = functorM;
  }

  public function map<A,B>(v:PromiseTOf<M, A>, f:A->B):PromiseTOf<M, B> 
  {
    function f1 (x) return Promises.map(x, f);

    return functorM.map(v.runT(), f1);
  }
}
