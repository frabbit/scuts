package hots.extensions;
import hots.instances.ArrayOfMonad;
import hots.Of;
import scuts.core.extensions.ArrayExt;
import hots.classes.Monad;


/**
 * ...
 * @author 
 */

class MonadExt 
{
  
  
  
  public static function lift2 <M, A1, A2, R>(m:Monad<M>, f:A1->A2->R ):Of<M, A1>->Of<M, A2>->Of<M, R>
  {
    return function (v1:Of<M, A1>, v2:Of<M, A2>) {
      return m.flatMap(v1, function (x1) {
        return m.flatMap(v2, function (x2) {
          return m.pure(f(x1,x2));
        });
      });
    };
  }
  
  public static function ap<M,A,B>(m:Monad<M>, f:Of<M, A->B>):Of<M, A>->Of<M,B> 
  {
    return function (v:Of<M,A>) {
      return m.flatMap(f, function (f1:A->B):Of<M,B> {
        return m.map(function (a2:A):B {
          return f1(a2);
        }, v);
      });
    };
    
  }
  public static function sequence <M,B>(monad:Monad<M>, arr:Array<Of<M, B>>):Of<M,Array<B>>
  {
    var arrMonad = ArrayOfMonad.get();
    var k = function (m1:Of<M,B>,m2:Of<M,Array<B>>) {
      return monad.flatMap(m1, function (x:B) {
        return monad.flatMap(m2, function (xs:Array<B>) {
          return monad.pure([x].concat(xs));
        });
      });
      
    }
    return ArrayExt.foldRight(arr, k, monad.pure([]));
  }
  
  public static inline function mapM <M,A,B>(mon:Monad<M>, f:A->Of<M,B>, a:Array<A>):Of<M,Array<B>>
  {
    return sequence(mon, ArrayExt.map(a,f));
  }
  
  // from functor
  
  
  
  
  
}