package scuts1.instances.std;


import scuts1.classes.Empty;
import scuts1.classes.Monoid;
import scuts1.core.In;
import scuts1.core.Of;
import scuts1.instances.std.ValidationOf;
import scuts.core.Validations;




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
