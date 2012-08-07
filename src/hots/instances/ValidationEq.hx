package hots.instances;

import hots.classes.Eq;
import hots.classes.EqAbstract;
import scuts.core.extensions.Tup2s;
import scuts.core.extensions.Validations;
import scuts.core.types.Tup2;
import scuts.core.types.Validation;


class ValidationEq<A,B> extends EqAbstract<Validation<F,S>> 
{
  
  var failureEq:Eq<B>;
  var successEq:Eq<A>;
  
  public function new (failureEq:Eq<B>, successEq:Eq<A> ) 
  {
    this.failureEq = failureEq;
    this.successEq = successEq;
  }
  
  override public inline function eq  (a:Tup2<A,B>, b:Tup2<A,B>):Bool 
  {
    return Validations.eq(a, b, failureEq.eq, successEq.eq);
  }
  
}
