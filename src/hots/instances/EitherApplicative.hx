package hots.instances;

import hots.classes.ApplicativeAbstract;
import hots.In;
import scuts.core.types.Either;

private typedef B = EitherBox;

class EitherApplicativeImpl<L> extends ApplicativeAbstract<Either<L,In>> {
  
  public function new () {
    super(EitherPointed.get());
  }
  
  override public function apply<A,B>(f:EitherOf<L,A->B>, val:EitherOf<L,A>):EitherOf<L,B> {
    var val1 = B.unbox(val);
    var res = switch (B.unbox(f)) {
      case Left(l):
        switch (val1) {
          case Left(l2): cast val1; // faster instead of Left(l2);
          case Right(r): Left(l);
        }
      case Right(r):
        switch (val1) {
          case Left(l): cast val1; // faster instead of Left(l);
          case Right(r2): Right(r(r2));
        }
    }
    return B.box(res);
  }
}

typedef EitherApplicative = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(EitherApplicativeImpl)]>;