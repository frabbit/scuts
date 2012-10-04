package hots.instances;


import hots.classes.MonadZeroAbstract;
import hots.classes.Monoid;
import hots.In;
import hots.Of;
import hots.of.ValidationOf;
import scuts.core.extensions.Validations;
import scuts.core.types.Validation;

using hots.box.ValidationBox;


class ValidationMonadZero<F> extends MonadZeroAbstract<Validation<F,In>> {
  
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
