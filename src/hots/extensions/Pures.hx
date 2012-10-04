package hots.extensions;
import hots.classes.Applicative;
import hots.classes.Monad;
import hots.classes.Pure;
import hots.Of;


class Pures
{
  public static function pure<M,A>(x:A, m:Pure<M>):Of<M, A>
  {
    return m.pure(x);
  }
  
}