package hots.instances;

import hots.classes.Functor;
import hots.classes.FunctorAbstract;
import hots.In;
import hots.Of;
import hots.of.PromiseTOf;
import scuts.core.extensions.Promises;
import scuts.core.types.Promise;
import scuts.core.types.Tup2;

using hots.ImplicitCasts;
using hots.Hots;
using hots.Identity;

using hots.box.StateBox;

class PromiseTFunctor<M> extends FunctorAbstract<Of<M, Promise<In>>> {
  
  var functorM:Functor<M>;
  
  public function new (functorM:Functor<M>) 
  {
    this.functorM = functorM;
  }

  override public function map<A,B>(v:PromiseTOf<M, A>, f:A->B):PromiseTOf<M, B> 
  {
    function f1 (x) return Promises.map(x, f);

    return functorM.map(v.runT(), f1);
  }
}
