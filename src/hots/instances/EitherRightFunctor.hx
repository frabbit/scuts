package hots.instances;

import hots.classes.FunctorAbstract;
import hots.of.EitherOf;
import scuts.core.extensions.Eithers;

import hots.classes.Monad;

import hots.In;
import scuts.core.types.Either;
import scuts.core.extensions.Eithers;


class EitherRightFunctor<L> extends FunctorAbstract<RightProjection<L,In>> 
{
  public function new () {}
  
  override public function map<R,RR>(of:RightProjectionOf<L,R>, f:R->RR):RightProjectionOf<L,RR> 
  {
    return RightProjections.map(of, f);
  }

}
