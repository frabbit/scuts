package hots.classes;
import hots.OfOf;
import hots.Of;

import scuts.core.Tup2;
import scuts.Scuts;

/**
 * ...
 * @author 
 */

class ArrowZeroAbstract<AR> implements ArrowZero<AR>
{
  var arrow:Arrow<AR>;
  
  function new (arrow:Arrow<AR>) this.arrow = arrow
  
  public function zero <B,C>():OfOf<AR, B, C> return Scuts.abstractMethod()
  
  
  // delegation
  
  public inline function arr <B,C>(f:B->C):OfOf<AR,B, C> return arrow.arr(f)
  
  public inline function first <B,C,D>(f:OfOf<AR,B,C>):OfOf<AR, Tup2<B,D>, Tup2<C,D>> return arrow.first(f)
  
  public inline function second <B,C,D>(f:OfOf<AR,B, C>):OfOf<AR, Tup2<D,B>, Tup2<D,C>> return arrow.second(f)
  
  public inline function split <B,B1, C,C1,D >(f:OfOf<AR,B, C>, g:OfOf<AR, B1, C1>):OfOf<AR, Tup2<B,B1>, Tup2<C,C1>> return arrow.split(f,g)
  
  public inline function fanout <B,C, C1>(f:OfOf<AR,B, C>, g:OfOf<AR, B, C1>):OfOf<AR, B, Tup2<C,C1>> return arrow.fanout(f,g)
  
  public inline function id <A>(a:A):OfOf<AR, A, A> return arrow.id(a)

  public inline function dot <A,B,C>(g:OfOf<AR, B, C>, f:OfOf<AR, A, B>):OfOf<AR, A, C> return arrow.dot(g,f)
  
  public inline function next <A,B,C>(f:OfOf<AR, A, B>, g:OfOf<AR, B, C>):OfOf<AR,A, C> return arrow.next(f,g)
  
  public inline function back <A,B,C>(g:OfOf<AR, B, C>, f:OfOf<AR, A, B>):OfOf<AR,A, C> return arrow.back(g,f)

}