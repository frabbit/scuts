package scuts.ht.classes;
import scuts.ht.core.Of;
import scuts.Scuts;




class MonadOrAbstract<M> implements MonadOr<M>
{
  var me:MonadEmpty<M>;
  
  function new (monadEmpty:MonadEmpty<M>) {
    this.me = monadEmpty;
  }
  
  public function orElse <A>(val1:Of<M,A>, val2:Of<M,A>):Of<M,A> return Scuts.abstractMethod();
  
  // delegation monad empty
  public inline function empty <A>():Of<M,A> return me.empty();
  
  public inline function flatMap<A,B>(val:Of<M,A>, f: A->Of<M,B>):Of<M,B> return me.flatMap(val,f);
  
  public inline function flatten <A> (val: Of<M, Of<M,A>>):Of<M,A> return me.flatten(val);
  
  public inline function map<A,B>(val:Of<M,A>, f:A->B):Of<M,B> return me.map(val, f);

  public inline function pure<A>(x:A):Of<M,A> return me.pure(x);
  
  public inline function apply<A,B>(f:Of<M,A->B>, val:Of<M,A>):Of<M,B> return me.apply(f,val);
  
  public inline function thenRight<A,B>(val1:Of<M,A>, val2:Of<M,B>):Of<M,B> return me.thenRight(val1,val2);
  
  public inline function thenLeft<A,B>(val1:Of<M,A>, val2:Of<M,B>):Of<M,A> return me.thenLeft(val1, val2);
  
}