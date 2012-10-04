package hots.instances;


import hots.classes.PureAbstract;
import hots.In;
import hots.of.ValidationOf;
import scuts.core.extensions.Validations;
import scuts.core.types.Validation;



using scuts.core.extensions.Validations;
using hots.box.ValidationBox;

class ValidationPure<F> extends PureAbstract<Validation<F,In>> 
{
  public function new () {}
  
  override public function pure<S>(x:S):ValidationOf<F,S> return x.toSuccess().box()
}
