package hots.instances;


import hots.classes.ApplicativeAbstract;
import hots.classes.Monoid;
import hots.classes.Semigroup;
import hots.In;
import hots.of.ValidationOf;
import scuts.core.extensions.Validations;

import scuts.core.types.Validation;



class ValidationApplicative<F> extends ApplicativeAbstract<Validation<F,In>> 
{
  var failureSemi:Semigroup<F>;
  
  public function new (failureSemi:Semigroup<F>, pure, functor) 
  {
    super(pure, functor);
    this.failureSemi = failureSemi;
  }
  
  override public function apply<S,SS>(f:ValidationOf<F,S->SS>, of:ValidationOf<F,S>):ValidationOf<F,SS> 
  {
    return Validations.apply(of, f, failureSemi.append);
  }
}
