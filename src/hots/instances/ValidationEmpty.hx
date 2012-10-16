package hots.instances;


import hots.classes.Empty;
import hots.classes.Monoid;
import hots.In;
import hots.Of;
import hots.of.ValidationOf;
import scuts.core.Validations;
import scuts.core.Validation;

using hots.box.ValidationBox;


class ValidationEmpty<F> implements Empty<Validation<F,In>> {
  
  private var failureMonoid:Monoid<F>;
  
  public function new (failureMonoid:Monoid<F>) 
  {
    this.failureMonoid = failureMonoid;
  }
  
  public function empty <S>():ValidationOf<F,S>
  {
    return Failure(failureMonoid.zero());
  }
}
