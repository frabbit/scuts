package hots.instances;


import hots.classes.ApplicativeAbstract;
import hots.classes.Monoid;
import hots.classes.Semigroup;
import hots.In;

import hots.instances.ValidationOf;
using scuts.core.extensions.ValidationExt;
import scuts.core.types.Validation;

using hots.box.ValidationBox;

class ValidationApplicative<F> extends ApplicativeAbstract<Validation<F,In>> {
  
  var failureSemi:Semigroup<F>;
  
  public function new (failureSemi:Semigroup<F>) {
    super(ValidationPointed.get());
    this.failureSemi = failureSemi;
  }
  
  override public function apply<S,SS>(f:ValidationOf<F,S->SS>, of:ValidationOf<F,S>):ValidationOf<F,SS> 
  {
    return of.unbox().apply(f.unbox(), failureSemi.append).box();
  }
}
