package scuts.ht.classes;
import scuts.ht.core.Of;
import scuts.Scuts;


#if false
class MonadPlusAbstract<M>
{
  var monad:Monad<M>;
  var _plus:Plus<M>;
  var _empty:Empty<M>;

  function new (monad:Monad<M>, empty:Empty<M>, plus:Plus<M>)
  {
    this.monad = monad;
    this._empty = empty;
    this._plus = plus;
  }

  /**
   * @see <a href="MonadPlus.html">scuts.ht.classes.MonadPlus</a>
   */
  public function plus <A>(val1:M<A>, val2:M<A>):M<A> return _plus.plus(val1, val2);

  // delegation of MonadZero

  /**
   * @see <a href="MonadZero.html">scuts.ht.classes.MonadZero</a>
   */
  public inline function empty <A>():M<A> return _empty.empty();

  // delegation Functor

  /**
   * @see <a href="Functor.html">scuts.ht.classes.Functor</a>
   */
  public inline function map<A,B>(val:M<A>, f:A->B):M<B> return monad.map(val,f);

  // delegation Pointed

  public inline function pure<A>(x:A):M<A> return monad.pure(x);

  // delegation Applicative

  /**
   * @see <a href="Applicative.html">scuts.ht.classes.Applicative</a>
   */
  public inline function apply<A,B>(f:M<A->B>, val:M<A>):M<B> return monad.apply(f,val);

  /**
   * @see <a href="Applicative.html">scuts.ht.classes.Applicative</a>
   */
  public inline function thenRight<A,B>(val1:M<A>, val2:M<B>):M<B> return monad.thenRight(val1,val2);

  /**
   * @see <a href="Applicative.html">scuts.ht.classes.Applicative</a>
   */
  public inline function thenLeft<A,B>(val1:M<A>, val2:M<B>):M<A> return monad.thenLeft(val1, val2);

  // delegation Monad

  /**
   * @see <a href="Monad.html">scuts.ht.classes.Monad</a>
   */
  public inline function flatMap<A,B>(val:M<A>, f: A->M<B>):M<B> return monad.flatMap(val,f);

  /**
   * @see <a href="Monad.html">scuts.ht.classes.Monad</a>
   */
  public inline function flatten <A> (val: M<M<A>>):M<A> return monad.flatten(val);

}

#end