package hots.classes;

import hots.classes.MonadZero;
import hots.Of;
import scuts.Scuts;



@:tcAbstract class MonadZeroAbstract<M> implements MonadZero<M>
{
  var m:Monad<M>;
  
  function new (monad:Monad<M>) this.m = monad

  // functions
  public function zero <A>():Of<M,A> return Scuts.abstractMethod()
  
  
  // delegation functor
  
  public inline function map<A,B>(f:A->B, val:Of<M,A>):Of<M,B> return m.map(f, val)

  // delegation applicative
  public inline function ret<A>(x:A):Of<M,A> return m.ret(x)
  
  public inline function apply<A,B>(f:Of<M,A->B>, val:Of<M,B>):Of<M,B> return m.apply(f,val)
  
  public inline function thenRight<A,B>(val1:Of<M,A>, val2:Of<M,B>):Of<M,B> return m.thenRight(val1,val2)
  
  public inline function thenLeft<A,B>(val1:Of<M,A>, val2:Of<M,B>):Of<M,A> return m.thenLeft(val1, val2)

  // delegation monad
  public inline function flatMap<A,B>(val:Of<M,A>, f: A->Of<M,B>):Of<M,B> return m.flatMap(val,f)
  
  public inline function flatten <A> (val: Of<M, Of<M,A>>):Of<M,A> return m.flatten(val)
  
}