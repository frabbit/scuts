package hots.instances;


import hots.classes.Bind;
import hots.classes.Semigroup;
import hots.In;
import hots.of.ValidationOf;
import scuts.core.extensions.Validations;
import scuts.core.types.Validation;


class ValidationBind<F> implements Bind<Validation<F,In>> {
  
  public function new () {}
  
  public function flatMap<S,SS>(of:ValidationOf<F,S>, f: S->ValidationOf<F,SS>):ValidationOf<F,SS> 
  {
    return Validations.flatMap(of, f);
  }
}
