package hots.instances;


import hots.classes.ApplicativeAbstract;
import hots.classes.Monoid;
import hots.classes.Semigroup;
import hots.In;

import hots.instances.ValidationOf;
using scuts.core.extensions.Validations;
import scuts.core.types.Validation;

import hots.instances.ValidationOfPointed;

using hots.box.ValidationBox;

class ValidationOfApplicative<F> extends ApplicativeAbstract<Validation<F,In>> 
{
  
  var failureSemi:Semigroup<F>;
  
  public function new (failureSemi:Semigroup<F>, pointed) 
  {
    super(pointed);
    this.failureSemi = failureSemi;
  }
  
  override public function apply<S,SS>(f:ValidationOf<F,S->SS>, of:ValidationOf<F,S>):ValidationOf<F,SS> 
  {
    return of.unbox().apply(f.unbox(), failureSemi.append).box();
  }
}
