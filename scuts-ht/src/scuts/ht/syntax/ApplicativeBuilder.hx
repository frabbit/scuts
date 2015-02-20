
package scuts.ht.syntax;

import scuts.ht.classes.Applicative;
import scuts.ht.classes.Apply;
import scuts.ht.classes.Functor;
import scuts.ht.classes.Pure;


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
  public function apply<A,B>(of:F<A>, f:F<A->B>):F<B> return _apply.apply(of, f);

  public inline function apply2 <A,B,C>(fa:F<A>, fb:F<B>, f:A->B->C):F<C>
  {
    return _apply.apply2(fa,fb,f);
  }

  public inline function apply3 <A,B,C,D>(fa:F<A>, fb:F<B>, fc:F<C>, f:A->B->C->D):F<D>
  {
    return _apply.apply3(fa,fb,fc, f);
  }

  public inline function lift2<A, B, C>(f: A -> B -> C): F<A> -> F<B> -> F<C>
    return _apply.lift2(f);

  public inline function lift3<A, B, C,D>(f: A -> B -> C ->D): F<A> -> F<B> -> F<C> -> F<D>
    return _apply.lift3(f);


  public function ap<A,B>(f:F<A->B>):F<A>->F<B>
  {
    return _apply.ap(f);
  }

  /**
   * @see <a href="Applicative.html">scuts.ht.classes.Applicative</a>
   */
  public function thenRight<A,B>(of1:F<A>, of2:F<B>):F<B> return of2;

  /**
   * @see <a href="Applicative.html">scuts.ht.classes.Applicative</a>
   */
  public function thenLeft<A,B>(of1:F<A>, of2:F<B>):F<A> return of1;

  // delegation of functor

  /**
   * @see <a href="Functor.html">scuts.ht.classes.Functor</a>
   */
  public inline function map<A,B>(of:F<A>, f:A->B):F<B> return _functor.map(of, f);

  // delegation of pure
  /**
   * @see <a href="Pure.html">scuts.ht.classes.Pure</a>
   */
  public inline function pure<A>(x:A):F<A> return _pure.pure(x);
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
//   public function thenRight<A,B>(of1:M<A>, of2:M<B>):M<B> return of2;

//   /**
//    * @see <a href="Applicative.html">scuts.ht.classes.Applicative</a>
//    */
//   public function thenLeft<A,B>(of1:M<A>, of2:M<B>):M<A> return of1;


// }