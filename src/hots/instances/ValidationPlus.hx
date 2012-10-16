package hots.instances;


import hots.classes.Monoid;
import hots.classes.Plus;
import hots.classes.Semigroup;
import hots.In;
import hots.Of;
import hots.of.ValidationOf;
import scuts.core.Validations; 
import scuts.core.Validation;

using scuts.core.Validations;

using hots.ImplicitCasts;
using hots.Hots;

class ValidationPlus<F> implements Plus<Validation<F,In>> 
{
  private var failureMonoid:Monoid<F>;
  
  public function new (failureMonoid:Monoid<F>) 
  {
    this.failureMonoid = failureMonoid;
  }
  
  public function plus <S>(a1:ValidationOf<F,S>, a2:ValidationOf<F,S>):ValidationOf<F,S>
  {
    return Validations.append(a1, a2, failureMonoid.append, function (a,b) return b);
  }
}
