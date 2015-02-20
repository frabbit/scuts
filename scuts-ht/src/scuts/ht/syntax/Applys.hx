package scuts.ht.syntax;
import scuts.ht.classes.Apply;
import scuts.ht.classes.Bind;
import scuts.ht.classes.Functor;
import scuts.ht.core.Of;

using scuts.core.Functions;
import scuts.core.Tuples.*;

class Applys
{
  public static inline function apply<M,A,B>(x:M<A>, f:M<A->B>, a:Apply<M>):M<B> return a.apply(x, f);

  public static inline function apply2 <M,A,B,C>(fa:M<A>, fb:M<B>, f:A->B->C, a:Apply<M>):M<C>
  {
  	return a.apply2(fa,fb,f);
  }

  public static inline function apply3 <M,A,B,C,D>(fa:M<A>, fb:M<B>, fc:M<C>, f:A->B->C->D, a:Apply<M>):M<D>
  {
	  return a.apply3(fa,fb,fc,f);
  }

  public static inline function lift2<F,A, B, C>(f: A -> B -> C, a:Apply<F>): F<A> -> F<B> -> F<C>
    return a.lift2(f);

  public static inline function lift3<F,A, B, C,D>(f: A -> B -> C ->D, a:Apply<F>): F<A> -> F<B> -> F<C> -> F<D>
    return a.lift3(f);




  public static function ap<M,A,B>(f:M<A->B>, m:Apply<M>):M<A>->M<B>
  {
    return m.apply.bind(_, f);
  }


}
