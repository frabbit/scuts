package scuts.ht.instances.std;
import scuts.ht.instances.std.ArrayTOf;


import scuts.ht.core.In;
import scuts.ht.core.Of;
import scuts.ht.instances.std.ListTOf;
import scuts.core.Lists;
import scuts.ht.classes.Functor;

class ListTFunctor<M> implements Functor<Of<M,List<In>>> 
{
  var functorM:Functor<M>;
  
  public function new (functorM:Functor<M>) 
  {
    this.functorM = functorM;
  }

  public function map<A,B>(v:ListTOf<M, A>,f:A->B):ListTOf<M, B> 
  {

    return functorM.map(v, Lists.map.bind(_,f));
  }
}
