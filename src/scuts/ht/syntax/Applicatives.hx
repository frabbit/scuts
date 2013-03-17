package scuts.ht.syntax;
import scuts.ht.classes.Applicative;
import scuts.ht.classes.Apply;
import scuts.ht.classes.Functor;
import scuts.ht.classes.Monad;
import scuts.ht.core.Of;
import scuts.ht.classes.Pure;
import scuts.Scuts;
using scuts.core.Functions;
import scuts.core.Tuples.*;

class Applicatives
{
    
  public static inline function apply<M,A,B>(x:Of<M,A>, f:Of<M,A->B>, a:Applicative<M>):Of<M,B> return a.apply(f,x);

  public static inline function apply2 <M,A,B,C>(fa:Of<M,A>, fb:Of<M,B>, f:A->B->C, a:Applicative<M>):Of<M,C> 
  {
  	return apply(fb, a.map(fa, f.curry()), a);
  }

  public static inline function apply3 <M,A,B,C,D>(fa:Of<M,A>, fb:Of<M,B>, fc:Of<M,C>, f:A->B->C->D, a:Applicative<M>):Of<M,D> 
  {
	  return apply2.bind(apply2.bind(fa,fb,_, a)(tup2.bind(_,_)), fc, _, a)(function (ab,c) return f(ab._1, ab._2, c));
  }
  
  public static inline function lift2<F,A, B, C>(f: A -> B -> C, a:Applicative<F>): Of<F,A> -> Of<F,B> -> Of<F,C>
    return apply2.bind(_, _, f, a);

  public static inline function lift3<F,A, B, C,D>(f: A -> B -> C ->D, a:Applicative<F>): Of<F,A> -> Of<F,B> -> Of<F,C> -> Of<F,D>
    return apply3.bind(_, _, _, f, a);
  public static inline function thenRight<M,A,B>(x:Of<M,A>, y:Of<M,B>, a:Applicative<M>):Of<M,B>  return a.thenRight(x,y);
  

  public static inline function thenLeft<M,A,B>(x:Of<M,A>, y:Of<M,B>, a:Applicative<M>):Of<M,A>  return a.thenLeft(x, y);
  
  
  public static function ap<M,A,B>(f:Of<M, A->B>, m:Applicative<M>):Of<M, A>->Of<M,B> 
  {
    return m.apply.bind(f, _);
  }
  
  
  
}





