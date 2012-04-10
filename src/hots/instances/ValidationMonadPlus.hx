package hots.instances;


import hots.classes.Monad;
import hots.classes.MonadAbstract;
import hots.classes.MonadPlusAbstract;
import hots.classes.MonadZeroAbstract;
import hots.classes.Monoid;
import hots.classes.Semigroup;
import hots.In;
import hots.instances.ValidationOf;
import hots.Of;
import scuts.core.extensions.ValidationExt;
import scuts.core.types.Validation;

using hots.box.ValidationBox;

class ValidationMonadPlus<F> extends MonadPlusAbstract<Validation<F,In>> {
  
  private var failureMonoid:Monoid<F>;
  
  public function new (failureMonoid:Monoid<F>) {
    super(ValidationMonadZero.get(failureMonoid));
    this.failureMonoid = failureMonoid;
  }
  
  override public function append <S>(a1:ValidationOf<F,S>, a2:ValidationOf<F,S>):ValidationOf<F,S>
  {
    pure(failureMonoid.append(a1.unbox(), a2.unbox()));
  }
}
