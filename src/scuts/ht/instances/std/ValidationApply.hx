package scuts.ht.instances.std;


import scuts.ht.classes.Apply;
import scuts.ht.classes.Monoid;
import scuts.ht.classes.Semigroup;
import scuts.ht.core.In;
import scuts.ht.instances.std.ValidationOf;
import scuts.core.Validations;





class ValidationApply<F> implements Apply<Validation<F,In>> 
{
  var failureSemi:Semigroup<F>;
  
  public function new (failureSemi:Semigroup<F>) 
  {
    this.failureSemi = failureSemi;
  }
  
  public function apply<S,SS>(f:ValidationOf<F,S->SS>, of:ValidationOf<F,S>):ValidationOf<F,SS> 
  {
    return Validations.apply(of, f, failureSemi.append);
  }
}
