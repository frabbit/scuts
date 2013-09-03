
package scuts.ht.classes;

import scuts.ht.core.Of;

import scuts.core.Tuples.*;

using scuts.core.Functions;

class ApplyAbstract<M> implements Apply<M> {

  var _functor : Functor<M>;

  public function new (f:Functor<M>) {
  	this._functor = f;
  }

  public function map<A,B>(x:Of<M,A>, f:A->B):Of<M,B> {
  	return _functor.map(x, f);
  }

  public function apply<A,B>(val:Of<M,A>, f:Of<M,A->B>):Of<M,B> {
  	return Scuts.abstractMethod();
  }

  public inline function apply2 <A,B,C>(fa:Of<M,A>, fb:Of<M,B>, f:A->B->C):Of<M,C> 
  {
  	return apply(fb, map(fa, f.curry()));
  }

  public inline function apply3 <A,B,C,D>(fa:Of<M,A>, fb:Of<M,B>, fc:Of<M,C>, f:A->B->C->D):Of<M,D> 
  {
	  return apply2.bind(apply2.bind(fa,fb,_)(tup2.bind(_,_)), fc, _)(function (ab,c) return f(ab._1, ab._2, c));
  }
  
  public inline function lift2<A, B, C>(f: A -> B -> C): Of<M,A> -> Of<M,B> -> Of<M,C>
    return apply2.bind(_, _, f);

  public inline function lift3<A, B, C,D>(f: A -> B -> C ->D): Of<M,A> -> Of<M,B> -> Of<M,C> -> Of<M,D>
    return apply3.bind(_, _, _, f);
  
  
  public function ap<A,B>(f:Of<M, A->B>):Of<M, A>->Of<M,B> 
  {
    return apply.bind(_, f);
  }

}