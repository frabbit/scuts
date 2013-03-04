package scuts1.syntax;
import scuts1.classes.Applicative;
import scuts1.classes.Apply;
import scuts1.classes.Functor;
import scuts1.classes.Monad;
import scuts1.core.Of;
import scuts1.classes.Pure;
import scuts.Scuts;

class Applicatives
{
  
  public static inline function apply<M,A,B>(f:Of<M,A->B>, x:Of<M,A>, a:Applicative<M>):Of<M,B> return a.apply(f,x);
  

  public static inline function thenRight<M,A,B>(x:Of<M,A>, y:Of<M,B>, a:Applicative<M>):Of<M,B>  return a.thenRight(x,y);
  

  public static inline function thenLeft<M,A,B>(x:Of<M,A>, y:Of<M,B>, a:Applicative<M>):Of<M,A>  return a.thenLeft(x, y);
  
  
  public static function ap<M,A,B>(f:Of<M, A->B>, m:Applicative<M>):Of<M, A>->Of<M,B> 
  {
    return function (a) return m.apply(f, a);
  }
  
  
  
}





