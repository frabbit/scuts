package hots.classes;


import hots.Of;

import scuts.Scuts;

/**
 * 
 * In Contrast to the Haskell type class Applicative is the function pure 
 * part of the type class Pure.
 * 
 * The applicative type class in haskell.
 * 
 * class Functor f => Applicative f where
 *   -- | Lift a value.
 *   pure :: a -> f a
 *
 *   -- | Sequential application.
 *   (<*>) :: f (a -> b) -> f a -> f b
 *
 *   -- | Sequence actions, discarding the value of the first argument.
 *   (*>) :: f a -> f b -> f b
 *   (*>) = liftA2 (const id)
 *
 *   -- | Sequence actions, discarding the value of the second argument.
 *   (<*) :: f a -> f b -> f a
 *   (<*) = liftA2 const
 */
interface Applicative<M> implements Pure<M>, implements Functor<M>
{
  /**
   * Sequential Application. (Haskell Source)
   * 
   * Haskell: (<*>) :: f (a -> b) -> f a -> f b
   */
  public function apply<A,B>(f:Of<M,A->B>, val:Of<M,A>):Of<M,B>;
  
  /**
   * Sequence actions, discarding the value of the first argument. (Haskell Source)
   * 
   * haskell: (*>) :: f a -> f b -> f b
   */
  public function thenRight<A,B>(val1:Of<M,A>, val2:Of<M,B>):Of<M,B>;
  
  /**
   * Sequence actions, discarding the value of the second argument.
   * 
   * haskell: (<*) :: f a -> f b -> f a
   */
  public function thenLeft<A,B>(val1:Of<M,A>, val2:Of<M,B>):Of<M,A>;

}
