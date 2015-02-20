package scuts.ht.syntax;
import scuts.ht.classes.Applicative;
import scuts.ht.classes.Apply;
import scuts.ht.classes.Functor;
import scuts.ht.classes.Monad;
import scuts.ht.Context.Applicative;
import scuts.ht.classes.Pure;
import scuts.Scuts;


class Applicatives
{

  public static inline function thenRight<M,A,B>(x:M<A>, y:M<B>, a:Applicative<M>):M<B>  return a.thenRight(x,y);


  public static inline function thenLeft<M,A,B>(x:M<A>, y:M<B>, a:Applicative<M>):M<A>  return a.thenLeft(x, y);



}





