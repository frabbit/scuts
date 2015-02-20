package scuts.ht.instances.std;

import scuts.ht.classes.Empty;
import scuts.ht.classes.Monoid;
import scuts.core.Validations;




class ValidationEmpty<F> implements Empty<Validation<F,In>> {

  private var failureMonoid:Monoid<F>;

  public function new (failureMonoid:Monoid<F>)
  {
    this.failureMonoid = failureMonoid;
  }

  public function empty <S>():Validation<F,S>
  {
    return Failure(failureMonoid.zero());
  }
}
