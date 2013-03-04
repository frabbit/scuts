package scuts1.instances.std;


import scuts1.classes.Monoid;
import scuts1.classes.Plus;
import scuts1.classes.Semigroup;
import scuts1.core.In;
import scuts1.core.Of;
import scuts1.instances.std.ValidationOf;
import scuts.core.Validations; 
import scuts.core.Validation;

using scuts.core.Validations;




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
