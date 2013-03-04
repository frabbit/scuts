package scuts1.classes;

import scuts1.classes.Applicative;
import scuts1.core.Of;


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
  public function flatMap<A,B>(x:Of<M,A>, f:A->Of<M,B>):Of<M,B>;

}

















