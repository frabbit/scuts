package scuts.ht.classes;

import scuts.ht.classes.Applicative;

import scuts.Scuts;


interface Bind<M>
{
  /**
   * maps the function f over the value x and also flattens the result.
   *
   * aka: bind, >>=
   *
   * Haskell: >>= :: (a -> f b) -> f a -> f b
   */
  public function flatMap<A,B>(x:M<A>, f:A->M<B>):M<B>;

}

















