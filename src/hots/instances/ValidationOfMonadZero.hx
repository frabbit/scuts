package hots.instances;


import hots.classes.Monad;
import hots.classes.MonadAbstract;
import hots.classes.MonadZeroAbstract;
import hots.classes.Monoid;
import hots.classes.Semigroup;
import hots.In;
import hots.instances.ValidationOf;
import hots.instances.ValidationOfMonad;
import hots.Of;
import scuts.core.extensions.Validations;
import scuts.core.types.Validation;

using hots.box.ValidationBox;

class ValidationOfMonadZero<F> extends MonadZeroAbstract<Validation<F,In>> {
  
  private var failureMonoid:Monoid<F>;
  
  public function new (failureMonoid:Monoid<F>, monad ) 
  {
    super(monad);
    this.failureMonoid = failureMonoid;
  }
  
  override public function zero <S>():ValidationOf<F,S>
  {
    return Failure(failureMonoid.empty()).box();
  }
}
