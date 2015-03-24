package scuts.ht.instances.std;


import scuts.core.Lists;
import scuts.ht.classes.Functor;

class ListTFunctor<M> implements Functor<M<List<_>>>
{
  var functorM:Functor<M>;

  public function new (functorM:Functor<M>)
  {
    this.functorM = functorM;
  }

  public function map<A,B>(v:ListT<M, A>,f:A->B):ListT<M, B>
  {

    return functorM.map(v, Lists.map.bind(_,f));
  }
}
