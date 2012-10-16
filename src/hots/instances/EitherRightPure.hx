package hots.instances;



import hots.classes.Pure;
import hots.In;
import hots.of.EitherOf;
import scuts.core.Either;

using scuts.core.Eithers;

using hots.box.EitherBox;


class EitherRightPure<L> implements Pure<RightProjection<L,In>> 
{
  public function new () {}
  
  public function pure<A>(x:A):RightProjectionOf<L,A> 
  {
    return Right(x);
  }
}
