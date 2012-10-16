package hots.instances;

import hots.classes.Functor;
import hots.of.ValidationOf;
import scuts.core.Validations;
import scuts.core.Validation;
import hots.classes.Monad;
import hots.In;



class ValidationFunctor<F> implements Functor<Validation<F,In>> {
  
  public function new () {}
  
  public function map<S,SS>(of:ValidationOf<F,S>, f:S->SS):ValidationOf<F,SS> 
  {
    return Validations.map(of, f);
  }

}
