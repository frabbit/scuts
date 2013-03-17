package scuts.ht.instances.std;


import scuts.ht.classes.Apply;
import scuts.ht.classes.ApplyAbstract;
import scuts.ht.classes.Monoid;
import scuts.ht.classes.Semigroup;
import scuts.ht.core.In;
import scuts.ht.instances.std.ValidationOf;
import scuts.core.Validations;





class ValidationApply<F> extends ApplyAbstract<Validation<F,In>> 
{
  var failureSemi:Semigroup<F>;
  
  public function new (failureSemi:Semigroup<F>, func) 
  {
  	super(func);
    this.failureSemi = failureSemi;
  }
  
  override public function apply<S,SS>(of:ValidationOf<F,S>, f:ValidationOf<F,S->SS>):ValidationOf<F,SS> 
  {
    return Validations.apply(of, f, failureSemi.append);
  }
}
