package hots.instances;

import hots.classes.ApplicativeAbstract;
import hots.In;

import scuts.core.types.Either;

using hots.box.EitherBox;
using scuts.core.extensions.Eithers;

class EitherApplicative<L> extends ApplicativeAbstract<Either<L,In>> 
{
  
  public function new () 
  {
    super(EitherPointed.get());
  }
  
  override public function apply<A,B>(f:EitherOf<L,A->B>, of:EitherOf<L,A>):EitherOf<L,B> 
  {
    return of.unbox().applyRight(f.unbox()).box();
  }
}

