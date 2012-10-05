package hots.instances;
import hots.classes.Pure;
import hots.In;
import hots.Of;
import hots.of.PromiseTOf;
import scuts.core.extensions.Promises;
import scuts.core.types.Promise;
import scuts.core.types.Tup2;


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
