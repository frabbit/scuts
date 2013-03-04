package scuts1.syntax;


import scuts1.classes.MonadEmpty;

import scuts1.core.Of;
import scuts.core.Arrays;
import scuts1.classes.Monad;

import scuts1.classes.Applicative;
import scuts1.classes.Bind;
import scuts1.core.Of;

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
   * @see <a href="Monad.html">scuts1.classes.Monad</a>
   */
  public function flatMap<A,B>(val:Of<M,A>, f: A->Of<M,B>):Of<M,B> 
  {
    return bind.flatMap(val,f);
  }
  
  /**
   * @see <a href="Monad.html">scuts1.classes.Monad</a>
   */
  public function flatten <A> (val: Of<M, Of<M,A>>):Of<M,A> 
  {
    return flatMap(val, Scuts.id);
  }
  
  // delegation
  
  /**
   * @see <a href="Functor.html">scuts1.classes.Functor</a>
   */
  public function map<A,B>(val:Of<M,A>, f:A->B):Of<M,B> return applicative.map(val,f);

  /**
   * @see <a href="Pure.html">scuts1.classes.Pure</a>
   */
  public inline function pure<A>(x:A):Of<M,A> return applicative.pure(x);
  
  /**
   * @see <a href="Applicative.html#apply()">scuts1.classes.Applicative</a>
   */
  public inline function apply<A,B>(f:Of<M,A->B>, val:Of<M,A>):Of<M,B> return applicative.apply(f,val);
  
  /**
   * @see <a href="Applicative.html#thenRight()">scuts1.classes.Applicative</a>
   */
  public inline function thenRight<A,B>(val1:Of<M,A>, val2:Of<M,B>):Of<M,B> return applicative.thenRight(val1,val2);
  
  
  /**
   * @see <a href="Applicative.html#thenLeft()">scuts1.classes.Applicative</a>
   */
  public inline function thenLeft<A,B>(val1:Of<M,A>, val2:Of<M,B>):Of<M,A> return applicative.thenLeft(val1, val2);
}

