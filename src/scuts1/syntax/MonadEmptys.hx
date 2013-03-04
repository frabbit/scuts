package scuts1.syntax;
import scuts1.classes.Empty;
import scuts1.classes.Monad;
import scuts1.classes.MonadEmpty;

import scuts1.core.Of;

import scuts.Scuts;

class MonadEmptys 
{
  
  public static function empty <M,A>(m:MonadEmpty<M>):Of<M,A> return m.empty();
  
  public static function filter <M,A>(o:Of<M,A>, f:A->Bool, m:MonadEmpty<M>):Of<M,A> 
  {
    return m.flatMap(o, function (x) return if (f(x)) m.pure(x) else m.empty());
    
  }
  
}