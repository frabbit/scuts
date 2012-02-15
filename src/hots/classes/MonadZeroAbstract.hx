package hots.classes;

import hots.classes.MonadZero;
import hots.Of;
import scuts.Scuts;



@:tcAbstract class MonadZeroAbstract<M> implements MonadZero<M>
{
  var monad:Monad<M>;
  
  function new (monad:Monad<M>) this.monad = monad

  // functions
  public function zero <A>():Of<M,A> return Scuts.abstractMethod()
  
  // delegation monad
  
  @:final public inline function map<A,B>(f:A->B, val:Of<M,A>):Of<M,B> return monad.map(f, val)

  @:final public inline function pure<A>(x:A):Of<M,A> return monad.pure(x)
  
  @:final public inline function apply<A,B>(f:Of<M,A->B>, val:Of<M,A>):Of<M,B> return monad.apply(f,val)
  
  @:final public inline function thenRight<A,B>(val1:Of<M,A>, val2:Of<M,B>):Of<M,B> return monad.thenRight(val1,val2)
  
  @:final public inline function thenLeft<A,B>(val1:Of<M,A>, val2:Of<M,B>):Of<M,A> return monad.thenLeft(val1, val2)
  
  @:final public inline function flatMap<A,B>(val:Of<M,A>, f: A->Of<M,B>):Of<M,B> return monad.flatMap(val,f)
  
  @:final public inline function flatten <A> (val: Of<M, Of<M,A>>):Of<M,A> return monad.flatten(val)
  
}