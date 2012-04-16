package hots.instances;


import hots.classes.Monad;
import hots.classes.MonadAbstract;
import hots.classes.MonadZeroAbstract;
import hots.classes.Monoid;
import hots.classes.Semigroup;
import hots.In;
import hots.instances.ValidationOf;
import hots.Of;
import scuts.core.extensions.Validations;
import scuts.core.types.Validation;

using hots.box.ValidationBox;

class ValidationMonadZero<F> extends MonadZeroAbstract<Validation<F,In>> {
  
  private var failureMonoid:Monoid<F>;
  
  public function new (failureMonoid:Monoid<F> ) {
    super(ValidationMonad.get(failureMonoid));
    this.failureMonoid = failureMonoid;
  }
  
  override public function zero <S>():ValidationOf<F,S>
  {
    return Failure(failureMonoid.empty()).box();
  }
}
