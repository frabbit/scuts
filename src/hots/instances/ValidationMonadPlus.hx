package hots.instances;


import hots.classes.Monad;
import hots.classes.MonadAbstract;
import hots.classes.MonadPlusAbstract;
import hots.classes.MonadZeroAbstract;
import hots.classes.Monoid;
import hots.classes.Semigroup;
import hots.In;
import hots.Of;
import hots.of.ValidationOf;
import scuts.core.extensions.Validations; 
import scuts.core.types.Validation;

using scuts.core.extensions.Validations;

using hots.ImplicitCasts;
using hots.Hots;

class ValidationMonadPlus<F> extends MonadPlusAbstract<Validation<F,In>> 
{
  private var failureMonoid:Monoid<F>;
  
  public function new (failureMonoid:Monoid<F>, monZero) 
  {
    super(monZero);
    this.failureMonoid = failureMonoid;
  }
  
  override public function append <S>(a1:ValidationOf<F,S>, a2:ValidationOf<F,S>):ValidationOf<F,S>
  {
    return Validations.append(a1, a2, failureMonoid.append, function (a,b) return b);
  }
}
