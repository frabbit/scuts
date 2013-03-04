package scuts1.instances.std;

import scuts1.classes.Apply;
import scuts1.core.In;
import scuts1.instances.std.EitherOf;

import scuts.core.Either;

import scuts.core.Eithers;

class EitherRightApply<L> implements Apply<RightProjection<L,In>> 
{
  public function new () {}
  
  public function apply<A,B>(f:RightProjectionOf<L,A->B>, x:RightProjectionOf<L,A>):RightProjectionOf<L,B> 
  {
    return RightProjections.apply(x, f);
  }
}

