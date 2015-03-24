package scuts.ht.instances.std;


import scuts.ht.classes.Bind;
import scuts.ht.classes.Monad;
import scuts.core.Eithers;




class EitherBind<L> implements Bind<Either<L,_>>
{
  public function new () {}

  public function flatMap<R,RR>(x:Either<L,R>, f: R->Either<L,RR>):Either<L,RR>
  {
    return Eithers.flatMapRight(x, f);
  }
}
