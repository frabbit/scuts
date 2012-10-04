package hots.classes;

import hots.Of;

import scuts.Scuts;


interface Functor<F> 
{
  /**
   * Maps the function f over the value x.
   * 
   * Haskell: fmap :: (a -> b) -> f a -> f b
   */
  public function map<A,B>(x:Of<F,A>, f:A->B):Of<F,B>;
}

















