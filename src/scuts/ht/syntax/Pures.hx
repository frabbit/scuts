package scuts.ht.syntax;
import scuts.ht.classes.Applicative;
import scuts.ht.classes.Monad;
import scuts.ht.classes.Pure;
import scuts.ht.core.Of;


class Pures
{
  public static function pure<M,A>(x:A, m:Pure<M>):Of<M, A>
  {
    return m.pure(x);
  }
  
}