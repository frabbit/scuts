package scuts.ht.classes;

import scuts.ht.core.OfOf;

using scuts.core.Tuples;

import scuts.Scuts;

using scuts.ht.syntax.Arrows;
using scuts.ht.syntax.Categorys;

class ArrowAbstract<AR> implements Arrow<AR>
{

  var c:Category<AR>;
  

  function new (category:Category<AR>) this.c = category;
  
  public function arr <B,C>(f:B->C):OfOf<AR,B, C> return Scuts.abstractMethod();
  
  public function first <B,C,D>(f:OfOf<AR,B,C>):OfOf<AR, Tup2<B,D>, Tup2<C,D>> return Scuts.abstractMethod();
  
  
  public function second <B,C,D>(f:OfOf<AR,B, C>):OfOf<AR, Tup2<D,B>, Tup2<D,C>> 
  {
    return arr(Tup2s.swap).next(first(f), c).next(arr(Tup2s.swap), c);
  }
  
  public function split <B,B1, C,C1,D >(f:OfOf<AR,B, C>, g:OfOf<AR, B1, C1>):OfOf<AR, Tup2<B,B1>, Tup2<C,C1>> 
  {
    return first(f).next(second(g), c);
  }
  
  public function fanout <B,C, C1>(f:OfOf<AR,B, C>, g:OfOf<AR, B, C1>):OfOf<AR, B, Tup2<C,C1>> {
    return arr(function (x:B) return Tup2.create(x,x))
      .next(split(f, g), c);
  }
  
  // delegation
  public inline function id <A>(a:A):OfOf<AR, A, A> return c.id(a);

  public inline function dot <A,B,C>(g:OfOf<AR, B, C>, f:OfOf<AR, A, B>):OfOf<AR, A, C> return c.dot(g,f);
  
  public inline function next <A,B,C>(f:OfOf<AR, A, B>, g:OfOf<AR, B, C>):OfOf<AR,A, C> return c.next(f,g);
  
  public inline function back <A,B,C>(g:OfOf<AR, B, C>, f:OfOf<AR, A, B>):OfOf<AR,A, C> return c.back(g,f);
  
}

