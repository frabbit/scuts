package hots.classes;

import hots.classes.Applicative;
import hots.Of;

import scuts.Scuts;

/**
 * Either flatMap or flatten must be overriden by classes extending MonadAbstract
 */
@:tcAbstract class MonadAbstract<M> implements Monad<M> 
{
  private var applicative:Applicative<M>;
  
  function new (applicative:Applicative<M>) this.applicative = applicative
 
  // functions
  public function flatMap<A,B>(val:Of<M,A>, f: A->Of<M,B>):Of<M,B> 
  {
    return flatten(map(val,f));
  }
  
  public function flatten <A> (val: Of<M, Of<M,A>>):Of<M,A> 
  {
    return flatMap(val, Scuts.id);
  }
  
  // delegation
  public inline function map<A,B>(val:Of<M,A>, f:A->B):Of<M,B> return applicative.map(val,f)

  public inline function pure<A>(x:A):Of<M,A> return applicative.pure(x)
  
  public inline function apply<A,B>(f:Of<M,A->B>, val:Of<M,A>):Of<M,B> return applicative.apply(f,val)
  
  public inline function thenRight<A,B>(val1:Of<M,A>, val2:Of<M,B>):Of<M,B> return applicative.thenRight(val1,val2)
  
  public inline function thenLeft<A,B>(val1:Of<M,A>, val2:Of<M,B>):Of<M,A> return applicative.thenLeft(val1, val2)
}

















