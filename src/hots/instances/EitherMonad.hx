package hots.instances;

import hots.classes.Monad;
import hots.classes.MonadAbstract;
import hots.In;
import scuts.core.types.Either;

typedef B = EitherBox;

class EitherMonadImpl<L> extends MonadAbstract<Either<L,In>> {
  
  public function new () {
    super(EitherApplicative.get());
  }
  
  override public function flatMap<A,B>(val:EitherOf<L,A>, f: A->EitherOf<L,B>):EitherOf<L,B> {
    var o = B.unbox(val);
    
    return switch(o) {
      case Left(v): B.box(Left(v));
      case Right(v): f(v);
    };
  }
}

typedef EitherMonad = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(EitherMonadImpl)]>;