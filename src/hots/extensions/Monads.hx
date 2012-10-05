package hots.extensions;


import hots.classes.MonadEmpty;

import hots.Of;
import scuts.core.extensions.Arrays;
import hots.classes.Monad;

typedef MonadExtApplicativeExt = hots.extensions.Applicatives;

class Monads 
{
  public static inline function flatMap <M,A,B> (x:Of<M, A>, f:A->Of<M, B>, m:Monad<M>):Of<M,B> return m.flatMap(x, f)
  
  public static inline function flatten <M,A> (x:Of<M, Of<M,A>>, m:Monad<M>):Of<M,A> return m.flatten(x)
  
  
  // Some Helper functions for working with monads
  
  public static function lift2 <M, A1, A2, R>(f:A1->A2->R, m:Monad<M>):Of<M, A1>->Of<M, A2>->Of<M, R>
  {
    return function (v1:Of<M, A1>, v2:Of<M, A2>) {
      return m.flatMap(v1, function (x1) 
        return m.flatMap(v2, function (x2) 
          return m.pure(f(x1,x2))
        )
      );
    }
  }
  
  public static function ap<M,A,B>(f:Of<M, A->B>, m:Monad<M>):Of<M, A>->Of<M,B> 
  {
    return function (v:Of<M,A>) {
      return m.flatMap(f, function (f1:A->B) 
        return m.map(v,function (a2:A) return f1(a2))
      );
    }
  }
  
  public static function sequence <M,B>(arr:Array<Of<M, B>>, m:Monad<M>):Of<M,Array<B>>
  {
    var k = function (m1:Of<M,B>,m2:Of<M,Array<B>>) {
      return m.flatMap(m1, function (x:B) 
         return m.flatMap(m2, function (xs:Array<B>) 
          return m.pure([x].concat(xs))
          )
      );
    }
    return Arrays.foldRight(arr, m.pure([]), k);
  }
  
  public static inline function mapM <M,A,B>(a:Array<A>, f:A->Of<M,B>, m:Monad<M>):Of<M,Array<B>>
  {
    return sequence(Arrays.map(a,f), m);
  }
  
  public static function createFromApplicativeAndBind <M>(app:Applicative<M>, bind:Bind<M>):Monad<M> {
    return new MonadFromApplicativeAndBind(app, bind);
  }
}



import hots.classes.Applicative;
import hots.classes.Bind;
import hots.Of;

import scuts.Scuts;

/**
 * Either flatMap or flatten must be overriden by classes extending MonadAbstract
 */
class MonadFromApplicativeAndBind<M> implements Monad<M> 
{
  private var applicative:Applicative<M>;
  private var bind:Bind<M>;
  
  public function new (applicative:Applicative<M>, bind:Bind<M>) {
    this.bind = bind;
    this.applicative = applicative;
  }
 
  // functions
  
  /**
   * @see <a href="Monad.html">hots.classes.Monad</a>
   */
  public function flatMap<A,B>(val:Of<M,A>, f: A->Of<M,B>):Of<M,B> 
  {
    return bind.flatMap(val,f);
  }
  
  /**
   * @see <a href="Monad.html">hots.classes.Monad</a>
   */
  public function flatten <A> (val: Of<M, Of<M,A>>):Of<M,A> 
  {
    return flatMap(val, Scuts.id);
  }
  
  // delegation
  
  /**
   * @see <a href="Functor.html">hots.classes.Functor</a>
   */
  public function map<A,B>(val:Of<M,A>, f:A->B):Of<M,B> return applicative.map(val,f)

  /**
   * @see <a href="Pure.html">hots.classes.Pure</a>
   */
  public inline function pure<A>(x:A):Of<M,A> return applicative.pure(x)
  
  /**
   * @see <a href="Applicative.html#apply()">hots.classes.Applicative</a>
   */
  public inline function apply<A,B>(f:Of<M,A->B>, val:Of<M,A>):Of<M,B> return applicative.apply(f,val)
  
  /**
   * @see <a href="Applicative.html#thenRight()">hots.classes.Applicative</a>
   */
  public inline function thenRight<A,B>(val1:Of<M,A>, val2:Of<M,B>):Of<M,B> return applicative.thenRight(val1,val2)
  
  
  /**
   * @see <a href="Applicative.html#thenLeft()">hots.classes.Applicative</a>
   */
  public inline function thenLeft<A,B>(val1:Of<M,A>, val2:Of<M,B>):Of<M,A> return applicative.thenLeft(val1, val2)
}

