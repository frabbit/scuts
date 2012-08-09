package hots.classes;

import hots.Of;

import scuts.Scuts;


interface Functor<F> 
{
  /**
   * Maps the function f:A->B over the monadic value F<A>.
   * Haskell: fmap :: (a -> b) -> f a -> f b
   */
  public function map<A,B>(val:Of<F,A>, f:A->B):Of<F,B>;
}

















