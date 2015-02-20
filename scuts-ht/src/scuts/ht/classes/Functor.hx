package scuts.ht.classes;

import scuts.Scuts;


interface Functor<F>
{
  /**
   * Maps the function f over the value x.
   *
   * Haskell: fmap :: (a -> b) -> f a -> f b
   */
  public function map<A,B>(x:F<A>, f:A->B):F<B>;
}

















