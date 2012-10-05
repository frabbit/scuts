package hots.instances;

import hots.classes.Apply;
import hots.In;
import hots.of.EitherOf;

import scuts.core.types.Either;

import scuts.core.extensions.Eithers;

class EitherRightApply<L> implements Apply<RightProjection<L,In>> 
{
  public function new () {}
  
  public function apply<A,B>(f:RightProjectionOf<L,A->B>, x:RightProjectionOf<L,A>):RightProjectionOf<L,B> 
  {
    return RightProjections.apply(x, f);
  }
}

