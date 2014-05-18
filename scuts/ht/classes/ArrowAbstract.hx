package scuts.ht.classes;

import scuts.ht.core.OfOf;

using scuts.core.Tuples;

import scuts.Scuts;

using scuts.ht.syntax.Arrows;
using scuts.ht.syntax.Categorys;

class ArrowAbstract<AR> implements Arrow<AR>
{

  function new () {}

  public function id <A>(a:A):OfOf<Cat, A, A> return Scuts.abstractMethod();

  public function dot <A,B,C>(g:OfOf<Cat, B, C>, f:OfOf<Cat, A, B>):OfOf<Cat, A, C> return Scuts.abstractMethod();

  public function next <A,B,C>(f:OfOf<Cat, A, B>, g:OfOf<Cat, B, C>):OfOf<Cat,A, C> return dot(g,f);

  public function back <A,B,C>(g:OfOf<Cat, B, C>, f:OfOf<Cat, A, B>):OfOf<Cat,A, C> return dot(g,f);

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

  public function fanout <B,C, C1>(f:OfOf<AR,B, C>, g:OfOf<AR, B, C1>):OfOf<AR, B, Tup2<C,C1>>
  {
    return
      arr(function (x:B) return Tup2.create(x,x))
      .next(split(f, g), c);
  }

}

