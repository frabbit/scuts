package scuts.ht.instances.std;

import scuts.ht.classes.Functor;
import scuts.ht.instances.std.ValidationOf;
import scuts.core.Validations;
import scuts.ht.classes.Monad;
import scuts.ht.core.In;



class ValidationFunctor<F> implements Functor<Validation<F,In>> {
  
  public function new () {}
  
  public function map<S,SS>(of:ValidationOf<F,S>, f:S->SS):ValidationOf<F,SS> 
  {
    return Validations.map(of, f);
  }

}
