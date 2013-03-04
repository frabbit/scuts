package scuts1.syntax;
import scuts1.classes.Applicative;
import scuts1.classes.Monad;
import scuts1.classes.Pure;
import scuts1.core.Of;


class Pures
{
  public static function pure<M,A>(x:A, m:Pure<M>):Of<M, A>
  {
    return m.pure(x);
  }
  
}