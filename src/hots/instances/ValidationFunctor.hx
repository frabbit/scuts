package hots.instances;

import hots.classes.FunctorAbstract;
import hots.instances.ValidationOf;
import scuts.core.extensions.ValidationExt;
import scuts.core.types.Validation;
import hots.classes.Monad;
import hots.In;


using hots.box.ValidationBox;

class ValidationFunctor<F> extends FunctorAbstract<Validation<F,In>> {
  
  public function new () {}
  
  override public function map<S,SS>(of:ValidationOf<F,S>, f:S->SS):ValidationOf<F,SS> 
  {
    return ValidationExt.map(of.unbox(), f).box();
  }

}
