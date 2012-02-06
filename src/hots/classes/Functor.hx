package hots.classes;

import hots.Of;
import hots.TC;
import scuts.Scuts;


interface Functor<F> implements TC
{
  /**
   * Maps the function f:A->B over the monadic value F<A>.
   * Haskell: fmap :: (a -> b) -> f a -> f b
   */
  public function map<A,B>(f:A->B, val:Of<F,A>):Of<F,B>;
}

















