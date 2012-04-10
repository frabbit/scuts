package hots.instances;

import hots.classes.FunctorAbstract;
import hots.classes.Semigroup;
import hots.classes.SemigroupAbstract;
import hots.instances.ValidationOf;
import scuts.core.extensions.ValidationExt;
import scuts.core.types.Validation;
import hots.classes.Monad;
import hots.In;


using hots.box.ValidationBox;

class ValidationSemigroup<F,S> extends SemigroupAbstract<Validation<F,S>> 
{
  private var semiF:Semigroup<F>;
  private var semiS:Semigroup<S>;

  public function new (semiF:Semigroup<F>, semiS:Semigroup<S>) {
    this.semiF = semiF;
    this.semiS = semiS;
  }
  
  override public function append(a1:Validation<F,S>, a2:Validation<F,S>):ValidationOf<F,S> 
  {
    
    return ValidationExt.append(map(of.unbox(), f).box();
  }

}
