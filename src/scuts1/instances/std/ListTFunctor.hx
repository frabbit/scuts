package scuts1.instances.std;
import scuts1.instances.std.ArrayTOf;


import scuts1.core.In;
import scuts1.core.Of;
import scuts1.instances.std.ListTOf;
import scuts.core.Lists;
import scuts1.classes.Functor;

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
