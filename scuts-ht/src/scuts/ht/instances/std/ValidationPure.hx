package scuts.ht.instances.std;


import scuts.ht.classes.Pure;
import scuts.core.Validations;



using scuts.core.Validations;


class ValidationPure<F> implements Pure<Validation<F,_>>
{
  public function new () {}

  public function pure<S>(x:S):Validation<F,S> return x.toSuccess();
}
