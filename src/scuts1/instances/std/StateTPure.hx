package scuts1.instances.std;
import scuts1.classes.Pure;
import scuts1.core.In;
import scuts1.core.Of;
import scuts1.instances.std.StateTOf;
import scuts.core.States;
import scuts.core.State;
import scuts.core.Tup2;



class StateTPure<M,ST> implements Pure<Of<M,State<ST, In>>> {
  
  var pureM:Pure<M>;

  public function new (pureM:Pure<M>) 
  {
    this.pureM = pureM;
  }

  /**
   * aka return
   */
  public function pure<A>(x:A):StateTOf<M,ST, A> {
    return pureM.pure(States.pure(x));
  }
  

}
