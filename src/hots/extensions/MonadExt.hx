package hots.extensions;
import hots.Of;
import scuts.core.extensions.ArrayExt;
import hots.classes.Monad;


/**
 * ...
 * @author 
 */

class MonadExt 
{

  public static function sequence <M,B>(monad:Monad<M>, arr:Array<Of<M, B>>):Of<M,Array<B>>
  {
    var arrMonad = ArrayMonad.get;
    var k = function (m1:Of<M,B>,m2:Of<M,Array<B>>) {
      return monad.flatMap(m1, function (x:B) {
        type(x);
        return monad.flatMap(m2, function (xs:Array<B>) {
          type(xs);
          return monad.ret([x].concat(xs));
        });
      });
      
    }
    return ArrayExt.foldRight(arr, k, monad.ret([]));
  }
  
  
  public static inline function mapM <M,A,B>(mon:Monad<M>, f:A->Of<M,B>, a:Array<A>):Of<M,Array<B>>
  {
    return sequence(ArrayExt.map(a,f), mon);
  }
  
  // from functor
  public static inline function map<M,A,B>(mon:Monad<M>, f:A->B, val:Of<M,A>):Of<M,B> {
    return mon.getFunctor().map(f, val);
  }
  
  // from applicative
  public static inline function ret<M,A>(mon:Monad<M>, x:A):Of<M,A> return mon.getApplicative().ret(x)
  /**
   * aka <*>
   */
  public static function apply<M,A,B>(mon:Monad<M>, val:Of<M,A->B>, f:Of<M,A>):Of<M,B> return mon.getApplicative().apply(x)
  
  /**
   * aka *>, >>, then
   */
  public static function thenRight<M,A,B>(mon:Monad<M>, val:MVal<M,A>, fb:MVal<M,B>):MVal<M,B> return mon.getApplicative().thenRight(x)
  
  /**
   * aka <*
   */
  public static function thenLeft<M,A,B>(mon:Monad<M>, val:MVal<M,A>, fb:MVal<M,B>):MVal<M,B> return mon.getApplicative().thenLeft(x)
  
  
}