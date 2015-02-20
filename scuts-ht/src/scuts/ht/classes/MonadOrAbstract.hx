package scuts.ht.classes;
import scuts.ht.core.Of;
import scuts.Scuts;


#if false

class MonadOrAbstract<M> implements MonadOr<M>
{
  var me:MonadEmpty<M>;

  function new (monadEmpty:MonadEmpty<M>) {
    this.me = monadEmpty;
  }

  public function orElse <A>(val1:M<A>, val2:M<A>):M<A> return Scuts.abstractMethod();

  // delegation monad empty
  public inline function empty <A>():M<A> return me.empty();

  public inline function flatMap<A,B>(val:M<A>, f: A->M<B>):M<B> return me.flatMap(val,f);

  public inline function flatten <A> (val: M<M<A>>):M<A> return me.flatten(val);

  public inline function map<A,B>(val:M<A>, f:A->B):M<B> return me.map(val, f);

  public inline function pure<A>(x:A):M<A> return me.pure(x);

  public inline function apply<A,B>(f:M<A->B>, val:M<A>):M<B> return me.apply(f,val);

  public inline function thenRight<A,B>(val1:M<A>, val2:M<B>):M<B> return me.thenRight(val1,val2);

  public inline function thenLeft<A,B>(val1:M<A>, val2:M<B>):M<A> return me.thenLeft(val1, val2);

}

#end