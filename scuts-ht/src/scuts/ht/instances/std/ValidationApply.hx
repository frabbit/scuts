package scuts.ht.instances.std;


import scuts.ht.classes.Apply;
import scuts.ht.classes.ApplyAbstract;
import scuts.ht.classes.Monoid;
import scuts.ht.classes.Semigroup;
import scuts.core.Validations;





class ValidationApply<F> extends ApplyAbstract<Validation<F,_>>
{
  var failureSemi:Semigroup<F>;

  public function new (failureSemi:Semigroup<F>, func)
  {
  	super(func);
    this.failureSemi = failureSemi;
  }

  override public function apply<S,SS>(of:Validation<F,S>, f:Validation<F,S->SS>):Validation<F,SS>
  {
    return Validations.apply(of, f, failureSemi.append);
  }
}
