package scuts1.instances.std;


import scuts1.classes.Apply;
import scuts1.classes.Monoid;
import scuts1.classes.Semigroup;
import scuts1.core.In;
import scuts1.instances.std.ValidationOf;
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
