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
  public function apply<A,B>(f:Of<M,A->B>, of:Of<M,B>):Of<M,B> return Scuts.abstractMethod()
  
  /**
   * aka *>
   */
  public function thenRight<A,B>(of1:Of<M,A>, of2:Of<M,B>):Of<M,B> return of2
  
  /**
   * aka <*
   */
  public function thenLeft<A,B>(of1:Of<M,A>, of2:Of<M,B>):Of<M,A> return of1

  
  // delegation of functor
  @:final public inline function map<A,B>(of:Of<M,A>, f:A->B):Of<M,B> return pointed.map(of, f)
  
  // delegation of pointed
  @:final public inline function pure<A>(x:A):Of<M,A> return pointed.pure(x)
}
