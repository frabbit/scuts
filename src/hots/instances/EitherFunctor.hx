package hots.instances;

import hots.classes.FunctorAbstract;

import hots.classes.Monad;

import hots.In;
import scuts.core.types.Either;


private typedef B = EitherBox;

class EitherFunctor<L> extends FunctorAbstract<Either<L,In>> {
  
  public function new () {}
  
  override public function map<A,B>(f:A->B, val:EitherOf<L,A>):EitherOf<L,B> 
  {
    var val1 = B.unbox(val);
    return B.box(
      switch (val1) {
        case Left(l):   cast val1;
        case Right(r):  Right(f(r));
      }
    );
 }
}

//typedef EitherFunctor = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(EitherFunctorImpl)]>;