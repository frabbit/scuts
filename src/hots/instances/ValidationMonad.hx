package hots.instances;


import hots.classes.MonadAbstract;
import hots.classes.Semigroup;
import hots.In;
import hots.of.ValidationOf;
import scuts.core.extensions.Validations;
import scuts.core.types.Validation;


class ValidationMonad<F> extends MonadAbstract<Validation<F,In>> {
  
  public function new (failureSemi:Semigroup<F>, app) 
  {
    super(app);
  }
  
  override public function flatMap<S,SS>(of:ValidationOf<F,S>, f: S->ValidationOf<F,SS>):ValidationOf<F,SS> 
  {
    return Validations.flatMap(of, f);
  }
}
