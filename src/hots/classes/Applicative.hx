package hots.classes;


import hots.Of;
import hots.TC;
import scuts.Scuts;



/**
 *  class (Functor f) => Applicative f where
   pure  :: a -> f a
   (<*>) :: f (a -> b) -> f a -> f b
 */

interface Applicative<M> implements Pointed<M>, implements TC
{
  /**
   * aka <*>
   */
  public function apply<A,B>(f:Of<M,A->B>, val:Of<M,A>):Of<M,B>;
  
  /**
   * aka *>
   */
  public function thenRight<A,B>(val1:Of<M,A>, val2:Of<M,B>):Of<M,B>;
  
  /**
   * aka <*
   */
  public function thenLeft<A,B>(val1:Of<M,A>, val2:Of<M,B>):Of<M,A>;

}
