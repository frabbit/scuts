package scuts.ht.instances.std;



import scuts.ht.classes.Pure;

import scuts.core.Eithers;

using scuts.core.Eithers;




class EitherPure<L> implements Pure<Either<L,_>>
{
  public function new () {}

  public function pure<A>(x:A):Either<L,A>
  {
    return Right(x);
  }
}
