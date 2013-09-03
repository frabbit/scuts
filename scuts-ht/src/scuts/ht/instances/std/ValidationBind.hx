package scuts.ht.instances.std;


import scuts.ht.classes.Bind;
import scuts.ht.classes.Semigroup;
import scuts.ht.core.In;
import scuts.ht.instances.std.ValidationOf;
import scuts.core.Validations;


class ValidationBind<F> implements Bind<Validation<F,In>> {
  
  public function new () {}
  
  public function flatMap<S,SS>(of:ValidationOf<F,S>, f: S->ValidationOf<F,SS>):ValidationOf<F,SS> 
  {
    return Validations.flatMap(of, f);
  }
}
