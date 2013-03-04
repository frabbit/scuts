package scuts1.instances.std;


import scuts1.classes.Pure;
import scuts1.core.In;
import scuts1.instances.std.ValidationOf;
import scuts.core.Validations;



using scuts.core.Validations;


class ValidationPure<F> implements Pure<Validation<F,In>> 
{
  public function new () {}
  
  public function pure<S>(x:S):ValidationOf<F,S> return x.toSuccess();
}
