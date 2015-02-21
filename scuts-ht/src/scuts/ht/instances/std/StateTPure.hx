package scuts.ht.instances.std;
import scuts.ht.classes.Pure;
import scuts.ht.core._;
import scuts.ht.core.Of;
import scuts.ht.instances.std.StateTOf;
import scuts.core.States;

import scuts.core.Tuples;



class StateTPure<M,ST> implements Pure<M<State<ST, _>>> {

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
