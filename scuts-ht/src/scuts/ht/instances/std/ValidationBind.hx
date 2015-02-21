package scuts.ht.instances.std;


import scuts.ht.classes.Bind;
import scuts.ht.classes.Semigroup;
import scuts.core.Validations;


class ValidationBind<F> implements Bind<Validation<F,_>> {

  public function new () {}

  public function flatMap<S,SS>(of:Validation<F,S>, f: S->Validation<F,SS>):Validation<F,SS>
  {
    return Validations.flatMap(of, f);
  }
}
