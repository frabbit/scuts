package hots.extensions;
import hots.classes.Applicative;
import hots.classes.Monad;
import hots.Of;


class Applicatives
{
  public static function ap<M,A,B>(m:Applicative<M>, f:Of<M, A->B>):Of<M, A>->Of<M,B> 
  {
    return function (a) return m.apply(f, a);
  }
  
}