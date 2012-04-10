package hots.instances;

import hots.classes.FunctorAbstract;
import scuts.core.extensions.EitherExt;

import hots.classes.Monad;

import hots.In;
import scuts.core.types.Either;


using hots.box.EitherBox;

class EitherFunctor<L> extends FunctorAbstract<Either<L,In>> {
  
  public function new () {}
  
  override public function map<R,RR>(of:EitherOf<L,R>, f:R->RR):EitherOf<L,RR> 
  {
    return EitherExt.mapRight(of.unbox(), f).box();
  }

}
