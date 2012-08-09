package hots.instances;

import hots.classes.Eq;
import hots.classes.EqAbstract;
import scuts.core.extensions.Tup2s;
import scuts.core.extensions.Validations;
import scuts.core.types.Tup2;
import scuts.core.types.Validation;


class ValidationEq<F,S> extends EqAbstract<Validation<F,S>> 
{
  
  var failureEq:Eq<F>;
  var successEq:Eq<S>;
  
  public function new (failureEq:Eq<F>, successEq:Eq<S> ) 
  {
    this.failureEq = failureEq;
    this.successEq = successEq;
  }
  
  override public inline function eq  (a:Validation<F,S>, b:Validation<F,S>):Bool 
  {
    return Validations.eq(a, b, failureEq.eq, successEq.eq);
  }
  
}
