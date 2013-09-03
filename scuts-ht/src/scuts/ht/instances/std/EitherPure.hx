package scuts.ht.instances.std;



import scuts.ht.classes.Pure;
import scuts.ht.core.In;
import scuts.ht.instances.std.EitherOf;
import scuts.core.Eithers;

using scuts.core.Eithers;




class EitherPure<L> implements Pure<Either<L,In>> 
{
  public function new () {}
  
  public function pure<A>(x:A):EitherOf<L,A> 
  {
    return Right(x);
  }
}
