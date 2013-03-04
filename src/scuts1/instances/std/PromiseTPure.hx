package scuts1.instances.std;
import scuts1.classes.Pure;
import scuts1.core.In;
import scuts1.core.Of;
import scuts1.instances.std.PromiseTOf;
import scuts.core.Promises;
import scuts.core.Tuples;


class PromiseTPure<M> implements Pure<Of<M,Promise<In>>> {
  
  var pureM:Pure<M>;

  public function new (pureM:Pure<M>) 
  {
    this.pureM = pureM;
  }

  /**
   * aka return
   */
  public function pure<A>(x:A):PromiseTOf<M,A> {
    return pureM.pure(Promises.pure(x));
  }
  

}
