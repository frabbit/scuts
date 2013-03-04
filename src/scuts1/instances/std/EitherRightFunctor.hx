package scuts1.instances.std;

import scuts1.classes.Functor;
import scuts1.instances.std.EitherOf;
import scuts.core.Eithers;

import scuts1.classes.Monad;

import scuts1.core.In;
import scuts.core.Either;
import scuts.core.Eithers;


class EitherRightFunctor<L> implements Functor<RightProjection<L,In>> 
{
  public function new () {}
  
  public function map<R,RR>(of:RightProjectionOf<L,R>, f:R->RR):RightProjectionOf<L,RR> 
  {
    return RightProjections.map(of, f);
  }

}
