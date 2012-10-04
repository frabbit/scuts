package hots.instances;

import hots.classes.ApplicativeAbstract;
import hots.In;
import hots.of.EitherOf;

import scuts.core.types.Either;

import scuts.core.extensions.Eithers;

class EitherRightApplicative<L> extends ApplicativeAbstract<RightProjection<L,In>> 
{
  
  public function new (pure, func) 
  {
    super(pure, func);
  }
  
  override public function apply<A,B>(f:RightProjectionOf<L,A->B>, x:RightProjectionOf<L,A>):RightProjectionOf<L,B> 
  {
    return RightProjections.apply(x, f);
  }
}

