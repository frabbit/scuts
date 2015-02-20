
package scuts.ht.classes;

import scuts.ht.core.Of;

import scuts.core.Tuples.*;

using scuts.core.Functions;

class ApplyAbstract<M> implements Apply<M> {

  var _functor : Functor<M>;

  public function new (f:Functor<M>) {
  	this._functor = f;
  }

  public function map<A,B>(x:M<A>, f:A->B):M<B> {
  	return _functor.map(x, f);
  }

  public function apply<A,B>(val:M<A>, f:M<A->B>):M<B> {
  	return Scuts.abstractMethod();
  }

  public inline function apply2 <A,B,C>(fa:M<A>, fb:M<B>, f:A->B->C):M<C>
  {
  	return apply(fb, map(fa, f.curry()));
  }

  public inline function apply3 <A,B,C,D>(fa:M<A>, fb:M<B>, fc:M<C>, f:A->B->C->D):M<D>
  {
	  return apply2.bind(apply2.bind(fa,fb,_)(tup2.bind(_,_)), fc, _)(function (ab,c) return f(ab._1, ab._2, c));
  }

  public inline function lift2<A, B, C>(f: A -> B -> C): M<A> -> M<B> -> M<C>
    return apply2.bind(_, _, f);

  public inline function lift3<A, B, C,D>(f: A -> B -> C ->D): M<A> -> M<B> -> M<C> -> M<D>
    return apply3.bind(_, _, _, f);


  public function ap<A,B>(f:M<A->B>):M<A>->M<B>
  {
    return apply.bind(_, f);
  }

}