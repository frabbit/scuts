package scuts.ht.instances.std;

import scuts.ht.classes.Pure;

using scuts.ht.instances.std.ValidationT;

using scuts.core.Validations;


class ValidationTPure<F, M> implements Pure<ValidationT<M,F, _>>
{
  var pureM:Pure<M>;

  public function new (pureM:Pure<M>)
  {
    this.pureM = pureM;
  }

  /**
   * aka return
   */
  public function pure<A>(x:A):ValidationT<M,F,A>
  {
    return pureM.pure(x.toSuccess()).validationT();
  }


}
