package hots.classes;


import hots.Of;
import scuts.Scuts;



/**
 *  class (Functor f) => Applicative f where
   pure  :: a -> f a
   (<*>) :: f (a -> b) -> f a -> f b
 */

@:tcAbstract class ApplicativeAbstract<M> implements Applicative<M>
{

  // constraint
  var functor:Functor<M>;
  
  function new (functor:Functor<M>) { this.functor = functor; }
  
  // functions 
  /**
   * aka return
   */
  public function ret<A>(x:A):Of<M,A> return Scuts.abstractMethod()
  /**
   * aka <*>
   */
  public function apply<A,B>(f:Of<M,A->B>, val:Of<M,B>):Of<M,B> return Scuts.abstractMethod()
  
  /**
   * aka *>
   */
  public function thenRight<A,B>(val1:Of<M,A>, val2:Of<M,B>):Of<M,B> return val2
  
  /**
   * aka <*
   */
  public function thenLeft<A,B>(val1:Of<M,A>, val2:Of<M,B>):Of<M,A> return val1

  // delegation
  @:final public inline function map<A,B>(f:A->B, val:Of<M,A>):Of<M,B> return functor.map(f, val)
}
