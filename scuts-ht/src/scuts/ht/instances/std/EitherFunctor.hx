package scuts.ht.instances.std;

import scuts.ht.classes.Functor;

import scuts.ht.classes.Monad;

import scuts.core.Eithers;


class EitherFunctor<L> implements Functor<Either<L,_>>
{
  public function new () {}

  public function map<R,RR>(of:Either<L,R>, f:R->RR):Either<L,RR>
  {
    return Eithers.mapRight(of, f);
  }

}
