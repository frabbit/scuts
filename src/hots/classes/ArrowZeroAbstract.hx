package hots.classes;
import hots.COf;
import hots.Of;

import scuts.core.types.Tup2;
import scuts.Scuts;

/**
 * ...
 * @author 
 */

@:tcAbstract class ArrowZeroAbstract<AR> implements ArrowZero<AR>
{
  var arrow:Arrow<AR>;
  
  function new (arrow:Arrow<AR>) this.arrow = arrow
  
  public function zero <B,C>():COf<AR, B, C> return Scuts.abstractMethod()
  
  
  // delegation
  
  @:final public inline function arr <B,C>(f:B->C):COf<AR,B, C> return arrow.arr(f)
  
  @:final public inline function first <B,C,D>(f:COf<AR,B,C>):COf<AR, Tup2<B,D>, Tup2<C,D>> return arrow.first(f)
  
  @:final public inline function second <B,C,D>(f:COf<AR,B, C>):COf<AR, Tup2<D,B>, Tup2<D,C>> return arrow.second(f)
  
  @:final public inline function split <B,B1, C,C1,D >(f:COf<AR,B, C>, g:COf<AR, B1, C1>):COf<AR, Tup2<B,B1>, Tup2<C,C1>> return arrow.split(f,g)
  
  @:final public inline function fanout <B,C, C1>(f:COf<AR,B, C>, g:COf<AR, B, C1>):COf<AR, B, Tup2<C,C1>> return arrow.fanout(f,g)
  
  @:final public inline function id <A>(a:A):COf<AR, A, A> return arrow.id(a)

  @:final public inline function dot <A,B,C>(g:COf<AR, B, C>, f:COf<AR, A, B>):COf<AR, A, C> return arrow.dot(g,f)
  
  @:final public inline function next <A,B,C>(f:COf<AR, A, B>, g:COf<AR, B, C>):COf<AR,A, C> return arrow.next(f,g)
  
  @:final public inline function back <A,B,C>(g:COf<AR, B, C>, f:COf<AR, A, B>):COf<AR,A, C> return arrow.back(g,f)

}