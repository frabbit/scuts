package scuts.ht.classes;


import scuts.ht.core.Of;

import scuts.Scuts;


interface Applicative<M> extends Pure<M> extends Apply<M>
{
  /**
   * Sequence actions, discarding the value of the first argument. (Haskell Source)
   *
   * haskell: (*>) :: f a -> f b -> f b
   */
  public function thenRight<A,B>(val1:M<A>, val2:M<B>):M<B>;

  /**
   * Sequence actions, discarding the value of the second argument. (Haskell Source)
   *
   * haskell: (<*) :: f a -> f b -> f a
   */
  public function thenLeft<A,B>(val1:M<A>, val2:M<B>):M<A>;

}
