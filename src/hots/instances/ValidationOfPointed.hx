package hots.instances;


import hots.classes.PointedAbstract;
import hots.In;
import hots.instances.ValidationOf;
import scuts.core.extensions.Validations;
import scuts.core.types.Validation;

import hots.instances.ValidationOfFunctor;

using scuts.core.extensions.Validations;
using hots.box.ValidationBox;

class ValidationOfPointed<F> extends PointedAbstract<Validation<F,In>> 
{
  public function new () 
  {
    super(ValidationOfFunctor.get());
  }
  
  override public function pure<S>(x:S):ValidationOf<F,S> return x.toSuccess().box()
}
