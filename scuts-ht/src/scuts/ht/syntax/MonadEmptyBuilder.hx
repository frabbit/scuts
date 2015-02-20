package scuts.ht.syntax;
import scuts.ht.classes.Empty;
import scuts.ht.classes.Monad;
import scuts.ht.classes.MonadEmpty;

import scuts.ht.core.Of;

import scuts.Scuts;

class MonadEmptyBuilder
{

  public static function createFromMonadAndEmpty <M>(m:Monad<M>, e:Empty<M>):MonadEmpty<M>
  {
    return new MonadEmptyDefault(m, e);
  }
}







class MonadEmptyDefault<M> implements MonadEmpty<M>
{
  var monad:Monad<M>;
  var _empty:Empty<M>;

  public function new (monad:Monad<M>, empty:Empty<M>) {
    this.monad = monad;
    this._empty = empty;
  }

  /**
   * @see <a href="MonadZero.html">scuts.ht.classes.MonadZero</a>
   */
  public function empty <A>():M<A> return _empty.empty();


  // delegation functor

  /**
   * @see <a href="Functor.html">scuts.ht.classes.Functor</a>
   */
  public inline function map<A,B>(val:M<A>, f:A->B):M<B> return monad.map(val,f);

  // delegation pointed

  public inline function pure<A>(x:A):M<A> return monad.pure(x);

  // delegation applicative
  /**
   * @see <a href="Applicative.html">scuts.ht.classes.Applicative</a>
   */
  public inline function apply<A,B>(val:M<A>, f:M<A->B>):M<B> return monad.apply(val, f);

  public inline function apply2 <A,B,C>(fa:M<A>, fb:M<B>, f:A->B->C):M<C>
  {
    return monad.apply2(fa,fb,f);
  }

  public inline function apply3 <A,B,C,D>(fa:M<A>, fb:M<B>, fc:M<C>, f:A->B->C->D):M<D>
  {
    return monad.apply3(fa,fb,fc, f);
  }

  public inline function lift2<A, B, C>(f: A -> B -> C): M<A> -> M<B> -> M<C>
    return monad.lift2(f);

  public inline function lift3<A, B, C,D>(f: A -> B -> C ->D): M<A> -> M<B> -> M<C> -> M<D>
    return monad.lift3(f);


  public function ap<A,B>(f:M<A->B>):M<A>->M<B>
  {
    return monad.ap(f);
  }

  /**
   * @see <a href="Applicative.html">scuts.ht.classes.Applicative</a>
   */
  public inline function thenRight<A,B>(val1:M<A>, val2:M<B>):M<B> return monad.thenRight(val1,val2);
  /**
   * @see <a href="Applicative.html">scuts.ht.classes.Applicative</a>
   */
  public inline function thenLeft<A,B>(val1:M<A>, val2:M<B>):M<A> return monad.thenLeft(val1, val2);

  // delegation monad

  /**
   * @see <a href="Monad.html">scuts.ht.classes.Monad</a>
   */
  public inline function flatMap<A,B>(val:M<A>, f: A->M<B>):M<B> return monad.flatMap(val,f);

  /**
   * @see <a href="Monad.html">scuts.ht.classes.Monad</a>
   */
  public inline function flatten <A> (val: M<M<A>>):M<A> return monad.flatten(val);

}