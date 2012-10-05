package hots.instances;


import hots.classes.Apply;
import hots.classes.Monoid;
import hots.classes.Semigroup;
import hots.In;
import hots.of.ValidationOf;
import scuts.core.extensions.Validations;

import scuts.core.types.Validation;



class ValidationApply<F> implements Apply<Validation<F,In>> 
{
  var failureSemi:Semigroup<F>;
  
  public function new (failureSemi:Semigroup<F>) 
  {
    this.failureSemi = failureSemi;
  }
  
  public function apply<S,SS>(f:ValidationOf<F,S->SS>, of:ValidationOf<F,S>):ValidationOf<F,SS> 
  {
    return Validations.apply(of, f, failureSemi.append);
  }
}
