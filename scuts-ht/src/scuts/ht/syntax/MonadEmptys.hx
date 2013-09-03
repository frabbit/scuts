package scuts.ht.syntax;
import scuts.ht.classes.Empty;
import scuts.ht.classes.Monad;
import scuts.ht.classes.MonadEmpty;

import scuts.ht.core.Of;

import scuts.Scuts;

class MonadEmptys 
{
  
  public static function empty <M,A>(m:MonadEmpty<M>):Of<M,A> return m.empty();
  
  public static function filter <M,A>(o:Of<M,A>, f:A->Bool, m:MonadEmpty<M>):Of<M,A> 
  {
    return m.flatMap(o, function (x) return if (f(x)) m.pure(x) else m.empty());
    
  }
  
}