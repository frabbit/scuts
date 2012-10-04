package hots.instances;

import hots.classes.FunctorAbstract;
import hots.of.ValidationOf;
import scuts.core.extensions.Validations;
import scuts.core.types.Validation;
import hots.classes.Monad;
import hots.In;



class ValidationFunctor<F> extends FunctorAbstract<Validation<F,In>> {
  
  public function new () {}
  
  override public function map<S,SS>(of:ValidationOf<F,S>, f:S->SS):ValidationOf<F,SS> 
  {
    return Validations.map(of, f);
  }

}
