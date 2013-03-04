package scuts1.instances.std;



import scuts1.classes.Pure;
import scuts1.core.In;
import scuts1.instances.std.EitherOf;
import scuts.core.Either;

using scuts.core.Eithers;




class EitherRightPure<L> implements Pure<RightProjection<L,In>> 
{
  public function new () {}
  
  public function pure<A>(x:A):RightProjectionOf<L,A> 
  {
    return Right(x).rightProjection();
  }
}
