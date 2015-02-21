package scuts.ht.instances.std;

import scuts.ht.classes.Functor;
import scuts.ht.instances.std.EitherOf;

import scuts.ht.classes.Monad;

import scuts.ht.core._;

import scuts.core.Eithers;


class EitherFunctor<L> implements Functor<Either<L,_>>
{
  public function new () {}

  public function map<R,RR>(of:EitherOf<L,R>, f:R->RR):EitherOf<L,RR>
  {
    return Eithers.mapRight(of, f);
  }

}
