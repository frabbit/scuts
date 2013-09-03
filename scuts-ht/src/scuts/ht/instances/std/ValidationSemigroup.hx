package scuts.ht.instances.std;

import scuts.ht.classes.Semigroup;
import scuts.core.Validations;

import scuts.ht.classes.Monad;
import scuts.ht.core.In;




class ValidationSemigroup<F,S> implements Semigroup<Validation<F,S>> 
{
  private var semiF:Semigroup<F>;
  private var semiS:Semigroup<S>;

  public function new (semiF:Semigroup<F>, semiS:Semigroup<S>) 
  {
    this.semiF = semiF;
    this.semiS = semiS;
  }
  
  public function append(a1:Validation<F,S>, a2:Validation<F,S>):Validation<F,S> 
  {
    return Validations.append(a1, a2, semiF.append, semiS.append);
  }

}
