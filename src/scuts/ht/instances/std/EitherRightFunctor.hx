package scuts.ht.instances.std;

import scuts.ht.classes.Functor;
import scuts.ht.instances.std.EitherOf;
import scuts.core.Eithers;

import scuts.ht.classes.Monad;

import scuts.ht.core.In;
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
