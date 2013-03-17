package scuts.ht.instances.std;



import scuts.ht.classes.Pure;
import scuts.ht.core.In;
import scuts.ht.instances.std.EitherOf;
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
