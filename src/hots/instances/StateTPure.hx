package hots.instances;
import hots.classes.Pure;
import hots.classes.PureAbstract;
import hots.In;
import hots.Of;
import hots.of.StateTOf;
import scuts.core.extensions.States;
import scuts.core.types.State;
import scuts.core.types.Tup2;



class StateTPure<M,ST> extends PureAbstract<Of<M,State<ST, In>>> {
  
  var pureM:Pure<M>;

  public function new (pureM:Pure<M>) 
  {
    this.pureM = pureM;
  }

  /**
   * aka return
   */
  override public function pure<A>(x:A):StateTOf<M,ST, A> {
    return pureM.pure(States.pure(x));
  }
  

}
