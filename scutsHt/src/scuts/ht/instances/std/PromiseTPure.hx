package scuts.ht.instances.std;
import scuts.ht.classes.Pure;
import scuts.ht.core.In;
import scuts.ht.core.Of;
import scuts.ht.instances.std.PromiseTOf;
import scuts.core.Promises;
import scuts.core.Tuples;


class PromiseTPure<M> implements Pure<Of<M,PromiseD<In>>> {
  
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
