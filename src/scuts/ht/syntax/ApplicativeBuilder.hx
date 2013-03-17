
package scuts.ht.syntax;

import scuts.ht.classes.Applicative;
import scuts.ht.classes.Apply;
import scuts.ht.classes.Functor;
import scuts.ht.classes.Pure;
import scuts.ht.core.Of;

class ApplicativeBuilder 
{
  public static function create <M>(pure:Pure<M>, apply:Apply<M>, functor:Functor<M> ):Applicative<M>
  {
    return new ApplicativeDefault(pure, apply, functor);
  }
}

class ApplicativeDefault<M> implements Applicative<M>
{

  // superclasses/constraints
  var _pure:Pure<M>;
  var _functor:Functor<M>;
  var _apply:Apply<M>;
  
  public function new (pure:Pure<M>, apply:Apply<M>, functor:Functor<M>) 
  { 
    this._pure = pure;
    this._functor = functor;
    this._apply = apply;
  }
  
  // functions 
  
  /**
   * @see <a href="Applicative.html">scuts.ht.classes.Applicative</a>
   */
  public function apply<A,B>(f:Of<M,A->B>, of:Of<M,A>):Of<M,B> return _apply.apply(f,of);
  
  /**
   * @see <a href="Applicative.html">scuts.ht.classes.Applicative</a>
   */
  public function thenRight<A,B>(of1:Of<M,A>, of2:Of<M,B>):Of<M,B> return of2;
  
  /**
   * @see <a href="Applicative.html">scuts.ht.classes.Applicative</a>
   */
  public function thenLeft<A,B>(of1:Of<M,A>, of2:Of<M,B>):Of<M,A> return of1;

  // delegation of functor
  
  /**
   * @see <a href="Functor.html">scuts.ht.classes.Functor</a>
   */
  public inline function map<A,B>(of:Of<M,A>, f:A->B):Of<M,B> return _functor.map(of, f);
  
  // delegation of pure
  /**
   * @see <a href="Pure.html">scuts.ht.classes.Pure</a>
   */
  public inline function pure<A>(x:A):Of<M,A> return _pure.pure(x);
}