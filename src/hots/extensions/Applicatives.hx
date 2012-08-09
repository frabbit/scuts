package hots.extensions;
import hots.classes.Applicative;
import hots.classes.Monad;
import hots.Implicit;
import hots.Of;


class Applicatives
{
  public static function ap<M,A,B>(f:Of<M, A->B>, m:Implicit<Applicative<M>>):Of<M, A>->Of<M,B> 
  {
    return function (a) return m.apply(f, a);
  }
  
}