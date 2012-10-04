package hots.instances;
import hots.classes.Pure;
import hots.classes.PureAbstract;
import hots.In;
import hots.Of;
import hots.of.PromiseTOf;
import scuts.core.extensions.Promises;
import scuts.core.types.Promise;
import scuts.core.types.Tup2;


class PromiseTPure<M> extends PureAbstract<Of<M,Promise<In>>> {
  
  var pureM:Pure<M>;

  public function new (pureM:Pure<M>) 
  {
    this.pureM = pureM;
  }

  /**
   * aka return
   */
  override public function pure<A>(x:A):PromiseTOf<M,A> {
    return pureM.pure(Promises.pure(x));
  }
  

}
