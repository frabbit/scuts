package scuts.ht.instances.std;

import scuts.ht.classes.Functor;
import scuts.core.Validations;
import scuts.ht.classes.Monad;



class ValidationFunctor<F> implements Functor<Validation<F,_>> {

  public function new () {}

  public function map<S,SS>(of:Validation<F,S>, f:S->SS):Validation<F,SS>
  {
    return Validations.map(of, f);
  }

}
