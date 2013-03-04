package scuts1.instances.std;

import scuts1.classes.Pure;

import scuts1.core.In;
import scuts1.core.Of;
import scuts1.instances.std.ValidationTOf;



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
