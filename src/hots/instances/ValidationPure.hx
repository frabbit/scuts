package hots.instances;


import hots.classes.Pure;
import hots.In;
import hots.of.ValidationOf;
import scuts.core.extensions.Validations;
import scuts.core.types.Validation;



using scuts.core.extensions.Validations;
using hots.box.ValidationBox;

class ValidationPure<F> implements Pure<Validation<F,In>> 
{
  public function new () {}
  
  public function pure<S>(x:S):ValidationOf<F,S> return x.toSuccess().box()
}
