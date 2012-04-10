package hots.instances;


import hots.classes.Monad;
import hots.classes.MonadAbstract;
import hots.classes.Semigroup;
import hots.In;
import hots.instances.ValidationOf;
import scuts.core.extensions.ValidationExt;
import scuts.core.types.Validation;

using hots.box.ValidationBox;

class ValidationMonad<F> extends MonadAbstract<Validation<F,In>> {
  
  public function new (failureSemi:Semigroup<F>) {
    super(ValidationApplicative.get(failureSemi));
  }
  
  override public function flatMap<S,SS>(of:ValidationOf<F,S>, f: S->ValidationOf<F,SS>):ValidationOf<F,SS> {
    return ValidationExt.flatMap(of.unbox(), f.unboxF()).box();
  }
}
