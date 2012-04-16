package hots.instances;


import hots.classes.PointedAbstract;
import hots.In;
import hots.instances.ValidationOf;
import scuts.core.extensions.Validations;
import scuts.core.types.Validation;

using hots.box.ValidationBox;

class ValidationPointed<F> extends PointedAbstract<Validation<F,In>> {
  
  public function new () {
    super(ValidationFunctor.get());
  }
  
  override public function pure<S>(x:S):ValidationOf<F,S> return Success(x).box()

}
