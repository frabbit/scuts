package hots.classes;

import hots.classes.Applicative;
import hots.Of;

import scuts.Scuts;

/**
 * Either flatMap or flatten must be overriden by classes extending MonadAbstract
 */
class MonadAbstract<M> implements Monad<M> 
{
  private var applicative:Applicative<M>;
  
  function new (applicative:Applicative<M>) this.applicative = applicative
 
  // functions
  
  /**
   * @see <a href="Monad.html">hots.classes.Monad</a>
   */
  public function flatMap<A,B>(val:Of<M,A>, f: A->Of<M,B>):Of<M,B> 
  {
    return flatten(map(val,f));
  }
  
  /**
   * @see <a href="Monad.html">hots.classes.Monad</a>
   */
  public function flatten <A> (val: Of<M, Of<M,A>>):Of<M,A> 
  {
    return flatMap(val, Scuts.id);
  }
  
  // delegation
  
  /**
   * @see <a href="Functor.html">hots.classes.Functor</a>
   */
  public function map<A,B>(val:Of<M,A>, f:A->B):Of<M,B> return applicative.map(val,f)

  /**
   * @see <a href="Pure.html">hots.classes.Pure</a>
   */
  public inline function pure<A>(x:A):Of<M,A> return applicative.pure(x)
  
  /**
   * @see <a href="Applicative.html#apply()">hots.classes.Applicative</a>
   */
  public inline function apply<A,B>(f:Of<M,A->B>, val:Of<M,A>):Of<M,B> return applicative.apply(f,val)
  
  /**
   * @see <a href="Applicative.html#thenRight()">hots.classes.Applicative</a>
   */
  public inline function thenRight<A,B>(val1:Of<M,A>, val2:Of<M,B>):Of<M,B> return applicative.thenRight(val1,val2)
  
  
  /**
   * @see <a href="Applicative.html#thenLeft()">hots.classes.Applicative</a>
   */
  public inline function thenLeft<A,B>(val1:Of<M,A>, val2:Of<M,B>):Of<M,A> return applicative.thenLeft(val1, val2)
}

















