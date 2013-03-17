package scuts.ht.instances.std;


import scuts.ht.classes.Pure;
import scuts.ht.core.In;
import scuts.ht.instances.std.ValidationOf;
import scuts.core.Validations;



using scuts.core.Validations;


class ValidationPure<F> implements Pure<Validation<F,In>> 
{
  public function new () {}
  
  public function pure<S>(x:S):ValidationOf<F,S> return x.toSuccess();
}
