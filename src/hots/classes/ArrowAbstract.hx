package hots.classes;

import hots.COf;
import hots.TC;
import scuts.core.extensions.Tup2Ext;
import scuts.core.types.Tup2;
import scuts.Scuts;

using hots.extensions.OfOfArrowExt;

@:tcAbstract class ArrowAbstract<AR> implements Arrow<AR>
{
  // constraints
  var c:Category<AR>;
  
  // constructor
  function new (category:Category<AR>) this.c = category
  
  // functions
  public function arr <B,C>(f:B->C):COf<AR,B, C> return Scuts.abstractMethod()
  
  public function first <B,C,D>(f:COf<AR,B,C>):COf<AR, Tup2<B,D>, Tup2<C,D>> return Scuts.abstractMethod()
  
  
  public function second <B,C,D>(f:COf<AR,B, C>):COf<AR, Tup2<D,B>, Tup2<D,C>> 
  {
    return arr(Tup2Ext.swap).next(first(f), c).next(arr(Tup2Ext.swap), c);
  }
  
  public function split <B,B1, C,C1,D >(f:COf<AR,B, C>, g:COf<AR, B1, C1>):COf<AR, Tup2<B,B1>, Tup2<C,C1>> 
  {
    return first(f).next(second(g), c);
  }
  
  public function fanout <B,C, C1>(f:COf<AR,B, C>, g:COf<AR, B, C1>):COf<AR, B, Tup2<C,C1>> {
    return arr(function (x:B) return Tup2.create(x,x))
      .next(split(f, g), c);
  }
  
  // delegation
  @:final public inline function id <A>(a:A):COf<AR, A, A> return c.id(a)

  @:final public inline function dot <A,B,C>(g:COf<AR, B, C>, f:COf<AR, A, B>):COf<AR, A, C> return c.dot(g,f)
  
  @:final public inline function next <A,B,C>(f:COf<AR, A, B>, g:COf<AR, B, C>):COf<AR,A, C> return c.next(f,g)
  
  @:final public inline function back <A,B,C>(g:COf<AR, B, C>, f:COf<AR, A, B>):COf<AR,A, C> return c.back(g,f)
  
}

