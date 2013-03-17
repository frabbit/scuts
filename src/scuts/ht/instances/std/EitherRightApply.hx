package scuts.ht.instances.std;

import scuts.ht.classes.Apply;
import scuts.ht.core.In;
import scuts.ht.instances.std.EitherOf;

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

