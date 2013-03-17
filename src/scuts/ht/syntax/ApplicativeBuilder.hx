
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

class ApplicativeDefault<F>  implements Applicative<F>
{

  // superclasses/constraints
  var _pure:Pure<F>;
  var _functor:Functor<F>;
  var _apply:Apply<F>;
  
  public function new (pure:Pure<F>, apply:Apply<F>, functor:Functor<F>) 
  { 
    this._pure = pure;
    this._functor = functor;
    this._apply = apply;
  }
  
  // functions 
  
  /**
   * @see <a href="Applicative.html">scuts.ht.classes.Applicative</a>
   */
  public function apply<A,B>(of:Of<F,A>, f:Of<F,A->B>):Of<F,B> return _apply.apply(of, f);
  
  public inline function apply2 <A,B,C>(fa:Of<F,A>, fb:Of<F,B>, f:A->B->C):Of<F,C> 
  {
    return _apply.apply2(fa,fb,f);
  }

  public inline function apply3 <A,B,C,D>(fa:Of<F,A>, fb:Of<F,B>, fc:Of<F,C>, f:A->B->C->D):Of<F,D> 
  {
    return _apply.apply3(fa,fb,fc, f);
  }
  
  public inline function lift2<A, B, C>(f: A -> B -> C): Of<F,A> -> Of<F,B> -> Of<F,C>
    return _apply.lift2(f);

  public inline function lift3<A, B, C,D>(f: A -> B -> C ->D): Of<F,A> -> Of<F,B> -> Of<F,C> -> Of<F,D>
    return _apply.lift3(f);
  
  
  public function ap<A,B>(f:Of<F, A->B>):Of<F, A>->Of<F,B> 
  {
    return _apply.ap(f);
  }

  /**
   * @see <a href="Applicative.html">scuts.ht.classes.Applicative</a>
   */
  public function thenRight<A,B>(of1:Of<F,A>, of2:Of<F,B>):Of<F,B> return of2;
  
  /**
   * @see <a href="Applicative.html">scuts.ht.classes.Applicative</a>
   */
  public function thenLeft<A,B>(of1:Of<F,A>, of2:Of<F,B>):Of<F,A> return of1;

  // delegation of functor
  
  /**
   * @see <a href="Functor.html">scuts.ht.classes.Functor</a>
   */
  public inline function map<A,B>(of:Of<F,A>, f:A->B):Of<F,B> return _functor.map(of, f);
  
  // delegation of pure
  /**
   * @see <a href="Pure.html">scuts.ht.classes.Pure</a>
   */
  public inline function pure<A>(x:A):Of<F,A> return _pure.pure(x);
}


// class ApplicativeDefault<M> implements Applicative<M> implements tink.lang.Cls
// {

//   // superclasses/constraints
//   @:forward var _pure:Pure<M>;
//   @:forward var _functor:Functor<M>;
//   @:forward var _apply:Apply<M>;
  
//   public function new (pure:Pure<M>, apply:Apply<M>, functor:Functor<M>) 
//   { 
//     this._pure = pure;
//     this._functor = functor;
//     this._apply = apply;
//   }
  
//   // functions 
  

//   /**
//    * @see <a href="Applicative.html">scuts.ht.classes.Applicative</a>
//    */
//   public function thenRight<A,B>(of1:Of<M,A>, of2:Of<M,B>):Of<M,B> return of2;
  
//   /**
//    * @see <a href="Applicative.html">scuts.ht.classes.Applicative</a>
//    */
//   public function thenLeft<A,B>(of1:Of<M,A>, of2:Of<M,B>):Of<M,A> return of1;

  
// }