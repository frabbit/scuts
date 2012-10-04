package hots.extensions;
import hots.classes.Applicative;
import hots.classes.Monad;
import hots.Of;


class Applicatives
{
  
  public static inline function apply<M,A,B>(f:Of<M,A->B>, val:Of<M,A>, a:Applicative<M>):Of<M,B> return a.apply(f,val)
  

  public static inline function thenRight<M,A,B>(val1:Of<M,A>, val2:Of<M,B>, a:Applicative<M>):Of<M,B>  return a.thenRight(val1,val2)
  

  public static inline function thenLeft<M,A,B>(val1:Of<M,A>, val2:Of<M,B>, a:Applicative<M>):Of<M,A>  return a.thenLeft(val1, val2)
  
  
  public static function ap<M,A,B>(f:Of<M, A->B>, m:Applicative<M>):Of<M, A>->Of<M,B> 
  {
    return function (a) return m.apply(f, a);
  }
  
}