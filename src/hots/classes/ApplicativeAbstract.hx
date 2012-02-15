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
  var pointed:Pointed<M>;
  
  function new (pointed:Pointed<M>) { this.pointed = pointed; }
  
  // functions 
  
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

  
  // delegation of functor
  @:final public inline function map<A,B>(f:A->B, val:Of<M,A>):Of<M,B> return pointed.map(f, val)
  
  // delegation of pointed
  @:final public inline function pure<A>(x:A):Of<M,A> return pointed.pure(x)
}
