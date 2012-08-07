package hots.instances;


import hots.classes.Monad;
import hots.classes.MonadAbstract;
import hots.classes.Semigroup;
import hots.In;
import hots.instances.ValidationOf;
import scuts.core.extensions.Validations;
import scuts.core.types.Validation;

import hots.instances.ValidationOfApplicative;

using hots.box.ValidationBox;

class ValidationOfMonad<F> extends MonadAbstract<Validation<F,In>> {
  
  public function new (failureSemi:Semigroup<F>) 
  {
    super(ValidationOfApplicative.get(failureSemi));
  }
  
  override public function flatMap<S,SS>(of:ValidationOf<F,S>, f: S->ValidationOf<F,SS>):ValidationOf<F,SS> 
  {
    return Validations.flatMap(of.unbox(), f.unboxF()).box();
  }
}
