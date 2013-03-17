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
  public function empty <A>():Of<M,A> return _empty.empty();
  
  
  // delegation functor
  
  /**
   * @see <a href="Functor.html">scuts.ht.classes.Functor</a>
   */
  public inline function map<A,B>(val:Of<M,A>, f:A->B):Of<M,B> return monad.map(val,f);

  // delegation pointed
  
  public inline function pure<A>(x:A):Of<M,A> return monad.pure(x);
  
  // delegation applicative
  /**
   * @see <a href="Applicative.html">scuts.ht.classes.Applicative</a>
   */
  public inline function apply<A,B>(f:Of<M,A->B>, val:Of<M,A>):Of<M,B> return monad.apply(f,val);
  /**
   * @see <a href="Applicative.html">scuts.ht.classes.Applicative</a>
   */
  public inline function thenRight<A,B>(val1:Of<M,A>, val2:Of<M,B>):Of<M,B> return monad.thenRight(val1,val2);
  /**
   * @see <a href="Applicative.html">scuts.ht.classes.Applicative</a>
   */
  public inline function thenLeft<A,B>(val1:Of<M,A>, val2:Of<M,B>):Of<M,A> return monad.thenLeft(val1, val2);
  
  // delegation monad
  
  /**
   * @see <a href="Monad.html">scuts.ht.classes.Monad</a>
   */
  public inline function flatMap<A,B>(val:Of<M,A>, f: A->Of<M,B>):Of<M,B> return monad.flatMap(val,f);
  
  /**
   * @see <a href="Monad.html">scuts.ht.classes.Monad</a>
   */
  public inline function flatten <A> (val: Of<M, Of<M,A>>):Of<M,A> return monad.flatten(val);
  
}