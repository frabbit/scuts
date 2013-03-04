package scuts1.instances.std;


import scuts1.classes.Bind;
import scuts1.classes.Semigroup;
import scuts1.core.In;
import scuts1.instances.std.ValidationOf;
import scuts.core.Validations;


class ValidationBind<F> implements Bind<Validation<F,In>> {
  
  public function new () {}
  
  public function flatMap<S,SS>(of:ValidationOf<F,S>, f: S->ValidationOf<F,SS>):ValidationOf<F,SS> 
  {
    return Validations.flatMap(of, f);
  }
}
