package hots.instances;

import hots.classes.Pure;
import hots.classes.PureAbstract;
import hots.In;
import hots.Of;
import hots.of.ValidationTOf;
import scuts.core.types.Option;
import scuts.core.types.Validation;

using scuts.core.extensions.Validations;

using hots.ImplicitCasts;
using hots.Hots;
using hots.Identity;


class ValidationTPure<F, M> extends PureAbstract<Of<M,Validation<F, In>>> 
{
  var pureM:Pure<M>;

  public function new (pureM:Pure<M>) 
  {
    this.pureM = pureM;
  }

  /**
   * aka return
   */
  override public function pure<A>(x:A):ValidationTOf<M,F,A> 
  {
    return pureM.pure(x.toSuccess()).intoT();
  }
  

}
