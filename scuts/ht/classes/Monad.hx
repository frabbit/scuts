package scuts.ht.classes;

import scuts.Scuts;


interface Monad<M> extends Functor<M>
{

  /**
   * flattens a nested monadic value.
   *
   * aka: join
   */
  public function flatten <A> (x:Of<M, Of<M,A>>):Of<M,A>;

  public function flatMap<A,B>(x:Of<M,A>, f:A->Of<M,B>):Of<M,B>;

  public function pure <A>(v:A):Of<M,A>;
}

















