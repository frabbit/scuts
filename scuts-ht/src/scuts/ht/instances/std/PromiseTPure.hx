package scuts.ht.instances.std;
import scuts.ht.classes.Pure;
import scuts.core.Promises;
using scuts.ht.instances.std.PromiseT;

import scuts.core.Tuples;


class PromiseTPure<M> implements Pure<PromiseT<M, _>> {

  var pureM:Pure<M>;

  public function new (pureM:Pure<M>)
  {
    this.pureM = pureM;
  }

  /**
   * aka return
   */
  public function pure<A>(x:A):PromiseT<M,A> {
    return pureM.pure(Promises.pure(x)).promiseT();
  }


}
