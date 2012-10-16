package hots.instances;
import hots.classes.Pure;
import hots.In;
import hots.Of;
import hots.of.StateTOf;
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
