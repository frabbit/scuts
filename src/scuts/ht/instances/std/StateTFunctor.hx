package scuts.ht.instances.std;

import scuts.ht.classes.Functor;

import scuts.ht.core.In;
import scuts.ht.core.Of;
import scuts.ht.instances.std.StateOf;
import scuts.ht.instances.std.StateTOf;
import scuts.core.States;
import scuts.core.State;
import scuts.core.Tup2;






class StateTFunctor<M,ST> implements Functor<Of<M, State<ST,In>>> {
  
  var functorM:Functor<M>;
  
  public function new (functorM:Functor<M>) 
  {
    this.functorM = functorM;
  }

  public function map<A,B>(v:StateTOf<M, ST, A>, f:A->B):StateTOf<M, ST, B> 
  {
    

    return functorM.map(v, States.map.bind(_, f));
  }
}
