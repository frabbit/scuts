package scuts.ht.instances.std;

import scuts.ht.classes.Functor;

using scuts.ht.instances.std.PromiseT;

import scuts.core.Promises;








class PromiseTFunctor<M> implements Functor<PromiseT<M, _>> {

  var functorM:Functor<M>;

  public function new (functorM:Functor<M>)
  {
    this.functorM = functorM;
  }

  public function map<A,B>(v:PromiseT<M, A>, f:A->B):PromiseT<M, B>
  {

    return functorM.map(v.runT(), Promises.map.bind(_,f)).promiseT();
  }
}
