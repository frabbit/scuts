package scuts.ht.instances.std;


import scuts.ht.classes.Monoid;
import scuts.ht.classes.Plus;
import scuts.ht.classes.Semigroup;
import scuts.ht.core._;
import scuts.ht.core.Of;
import scuts.ht.instances.std.ValidationOf;



using scuts.core.Validations;




class ValidationPlus<F> implements Plus<Validation<F,_>>
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
