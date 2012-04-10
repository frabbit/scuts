package hots.instances;


import hots.classes.Monad;
import hots.classes.MonadAbstract;
import hots.In;
import scuts.core.extensions.EitherExt;
import scuts.core.types.Either;

using hots.box.EitherBox;

class EitherMonad<L> extends MonadAbstract<Either<L,In>> {
  
  public function new () {
    super(EitherApplicative.get());
  }
  
  override public function flatMap<R,RR>(of:EitherOf<L,R>, f: R->EitherOf<L,RR>):EitherOf<L,RR> {
    return EitherExt.flatMapRight(of.unbox(), f.unboxF()).box();
  }
}
