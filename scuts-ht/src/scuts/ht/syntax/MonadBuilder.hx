package scuts.ht.syntax;


import scuts.ht.classes.MonadEmpty;

import scuts.ht.core.Of;
import scuts.core.Arrays;
import scuts.ht.classes.Monad;

import scuts.ht.classes.Applicative;
import scuts.ht.classes.Bind;
import scuts.ht.core.Of;

import scuts.Scuts;

class MonadBuilder
{


  public static function createFromApplicativeAndBind <M>(app:Applicative<M>, bind:Bind<M>):Monad<M> {
    return new MonadFromApplicativeAndBind(app, bind);
  }
}





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
   * @see <a href="Monad.html">scuts.ht.classes.Monad</a>
   */
  public function flatMap<A,B>(val:M<A>, f: A->M<B>):M<B>
  {
    return bind.flatMap(val,f);
  }

  /**
   * @see <a href="Monad.html">scuts.ht.classes.Monad</a>
   */
  public function flatten <A> (val: M<M<A>>):M<A>
  {
    return flatMap(val, Scuts.id);
  }

  // delegation

  /**
   * @see <a href="Functor.html">scuts.ht.classes.Functor</a>
   */
  public function map<A,B>(val:M<A>, f:A->B):M<B> return applicative.map(val,f);

  /**
   * @see <a href="Pure.html">scuts.ht.classes.Pure</a>
   */
  public inline function pure<A>(x:A):M<A> return applicative.pure(x);

  /**
   * @see <a href="Applicative.html#apply()">scuts.ht.classes.Applicative</a>
   */
  public inline function apply<A,B>(val:M<A>, f:M<A->B>):M<B> return applicative.apply(val, f);

  public inline function apply2 <A,B,C>(fa:M<A>, fb:M<B>, f:A->B->C):M<C>
  {
    return applicative.apply2(fa,fb,f);
  }

  public inline function apply3 <A,B,C,D>(fa:M<A>, fb:M<B>, fc:M<C>, f:A->B->C->D):M<D>
  {
    return applicative.apply3(fa,fb,fc, f);
  }

  public inline function lift2<A, B, C>(f: A -> B -> C): M<A> -> M<B> -> M<C>
    return applicative.lift2(f);

  public inline function lift3<A, B, C,D>(f: A -> B -> C ->D): M<A> -> M<B> -> M<C> -> M<D>
    return applicative.lift3(f);


  public function ap<A,B>(f:M<A->B>):M<A>->M<B>
  {
    return applicative.ap(f);
  }

  /**
   * @see <a href="Applicative.html#thenRight()">scuts.ht.classes.Applicative</a>
   */
  public inline function thenRight<A,B>(val1:M<A>, val2:M<B>):M<B> return applicative.thenRight(val1,val2);


  /**
   * @see <a href="Applicative.html#thenLeft()">scuts.ht.classes.Applicative</a>
   */
  public inline function thenLeft<A,B>(val1:M<A>, val2:M<B>):M<A> return applicative.thenLeft(val1, val2);
}

