package scuts1.instances.std;

import scuts1.classes.Functor;
import scuts1.instances.std.ValidationOf;
import scuts.core.Validations;
import scuts1.classes.Monad;
import scuts1.core.In;



class ValidationFunctor<F> implements Functor<Validation<F,In>> {
  
  public function new () {}
  
  public function map<S,SS>(of:ValidationOf<F,S>, f:S->SS):ValidationOf<F,SS> 
  {
    return Validations.map(of, f);
  }

}
