package scuts.ht.instances.std;


import scuts.ht.classes.Bind;
import scuts.ht.classes.Monad;
import scuts.ht.core.In;
import scuts.ht.instances.std.EitherOf;
import scuts.core.Eithers;




class EitherBind<L> implements Bind<Either<L,In>> 
{
  public function new () {}
  
  public function flatMap<R,RR>(x:EitherOf<L,R>, f: R->EitherOf<L,RR>):EitherOf<L,RR> 
  {
    return Eithers.flatMapRight(x, f);
  }
}
