package scuts1.instances.std;

import scuts1.classes.Functor;

import scuts1.core.In;
import scuts1.core.Of;
import scuts1.instances.std.StateOf;
import scuts1.instances.std.StateTOf;
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
