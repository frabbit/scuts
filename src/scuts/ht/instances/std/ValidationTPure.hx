package scuts.ht.instances.std;

import scuts.ht.classes.Pure;

import scuts.ht.core.In;
import scuts.ht.core.Of;
import scuts.ht.instances.std.ValidationTOf;



using scuts.core.Validations;





class ValidationTPure<F, M> implements Pure<Of<M,Validation<F, In>>> 
{
  var pureM:Pure<M>;

  public function new (pureM:Pure<M>) 
  {
    this.pureM = pureM;
  }

  /**
   * aka return
   */
  public function pure<A>(x:A):ValidationTOf<M,F,A> 
  {
    return pureM.pure(x.toSuccess());
  }
  

}
