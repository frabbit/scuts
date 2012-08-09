package hots.extensions;
import hots.classes.MonadZero;
import hots.Of;


class MonadZeros 
{

  public static function filter <M,A>(o:Of<M,A>, f:A->Bool, m:MonadZero<M>):Of<M,A> 
  {
    return m.flatMap(o, function (x) return if (f(x)) m.pure(x) else m.zero());
    
  }
  
}