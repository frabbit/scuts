package scuts.ht.classes;

import scuts.ht.classes.Applicative;


import scuts.Scuts;


interface Monad<M> extends Applicative<M> extends Bind<M>
{

  /**
   * flattens a nested monadic value.
   *
   * aka: join
   */
  public function flatten <A> (x:M<M<A>>):M<A>;
}

















