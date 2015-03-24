package scuts.ht.classes;

import scuts.core.Tuples;
import scuts.Scuts;

/**
 * ...
 * @author
 */

class ArrowZeroAbstract<AR> implements ArrowZero<AR>
{
  var arrow:Arrow<AR>;

  function new (arrow:Arrow<AR>) this.arrow = arrow;

  public function zero <B,C>():AR<B, C> return Scuts.abstractMethod();


  // delegation

  public inline function arr <B,C>(f:B->C):AR<B, C> return arrow.arr(f);

  public inline function first <B,C,D>(f:AR<B,C>):AR<Tup2<B,D>, Tup2<C,D>> return arrow.first(f);

  public inline function second <B,C,D>(f:AR<B, C>):AR<Tup2<D,B>, Tup2<D,C>> return arrow.second(f);

  public inline function split <B,B1, C,C1,D >(f:AR<B, C>, g:AR<B1, C1>):AR<Tup2<B,B1>, Tup2<C,C1>> return arrow.split(f,g);

  public inline function fanout <B,C, C1>(f:AR<B, C>, g:AR<B, C1>):AR<B, Tup2<C,C1>> return arrow.fanout(f,g);

  public inline function id <A>(a:A):AR<A, A> return arrow.id(a);

  public inline function dot <A,B,C>(g:AR<B, C>, f:AR<A, B>):AR<A, C> return arrow.dot(g,f);

  public inline function next <A,B,C>(f:AR<A, B>, g:AR<B, C>):AR<A, C> return arrow.next(f,g);

  public inline function back <A,B,C>(g:AR<B, C>, f:AR<A, B>):AR<A, C> return arrow.back(g,f);

}