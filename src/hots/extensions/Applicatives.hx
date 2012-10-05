package hots.extensions;
import hots.classes.Applicative;
import hots.classes.Apply;
import hots.classes.Functor;
import hots.classes.Monad;
import hots.Of;


class Applicatives
{
  
  public static inline function apply<M,A,B>(f:Of<M,A->B>, val:Of<M,A>, a:Applicative<M>):Of<M,B> return a.apply(f,val)
  

  public static inline function thenRight<M,A,B>(val1:Of<M,A>, val2:Of<M,B>, a:Applicative<M>):Of<M,B>  return a.thenRight(val1,val2)
  

  public static inline function thenLeft<M,A,B>(val1:Of<M,A>, val2:Of<M,B>, a:Applicative<M>):Of<M,A>  return a.thenLeft(val1, val2)
  
  
  public static function ap<M,A,B>(f:Of<M, A->B>, m:Applicative<M>):Of<M, A>->Of<M,B> 
  {
    return function (a) return m.apply(f, a);
  }
  
  public static function create <M>(pure:Pure<M>, apply:Apply<M>, functor:Functor<M> ):Applicative<M>
  {
    return new ApplicativeDefault(pure, apply, functor);
  }
  
}


import hots.classes.Pure;
import hots.Of;
import scuts.Scuts;



class ApplicativeDefault<M> implements Applicative<M>
{

  // superclasses/constraints
  var _pure:Pure<M>;
  var _functor:Functor<M>;
  var _apply:Apply<M>;
  
  public function new (pure:Pure<M>, apply:Apply<M>, functor:Functor<M>) { 
    this._pure = pure;
    this._functor = functor;
    this._apply = apply;
  }
  
  // functions 
  
  /**
   * @see <a href="Applicative.html">hots.classes.Applicative</a>
   */
  public function apply<A,B>(f:Of<M,A->B>, of:Of<M,A>):Of<M,B> return _apply.apply(f,of)
  
  /**
   * @see <a href="Applicative.html">hots.classes.Applicative</a>
   */
  public function thenRight<A,B>(of1:Of<M,A>, of2:Of<M,B>):Of<M,B> return of2
  
  /**
   * @see <a href="Applicative.html">hots.classes.Applicative</a>
   */
  public function thenLeft<A,B>(of1:Of<M,A>, of2:Of<M,B>):Of<M,A> return of1

  // delegation of functor
  
  /**
   * @see <a href="Functor.html">hots.classes.Functor</a>
   */
  public inline function map<A,B>(of:Of<M,A>, f:A->B):Of<M,B> return _functor.map(of, f)
  
  // delegation of pure
  /**
   * @see <a href="Pure.html">hots.classes.Pure</a>
   */
  public inline function pure<A>(x:A):Of<M,A> return _pure.pure(x)
}