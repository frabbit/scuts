package hots.classes;
import hots.Of;
import scuts.Scuts;



class MonadPlusAbstract<M>
{
  var mz:MonadZero<M>;
  
  public inline function getMonadZero ():MonadZero<M> return mz
  
  function new (monadZero:MonadZero<M>) 
  {
    this.mz = monadZero;
  }
    
  public function append <A>(val1:Of<M,A>, val2:Of<M,A>):Of<M,A> return Scuts.abstractMethod()
    
  // delegation of MonadZero 
  
  public inline function zero <A>():Of<M,A> return mz.zero()
  
  // delegation Functor
  
  public inline function map<A,B>(val:Of<M,A>, f:A->B):Of<M,B> return mz.map(val,f)

  // delegation Pointed
  
  public inline function pure<A>(x:A):Of<M,A> return mz.pure(x)
  
  // delegation Applicative
  
  public inline function apply<A,B>(f:Of<M,A->B>, val:Of<M,A>):Of<M,B> return mz.apply(f,val)
  
  public inline function thenRight<A,B>(val1:Of<M,A>, val2:Of<M,B>):Of<M,B> return mz.thenRight(val1,val2)
  
  public inline function thenLeft<A,B>(val1:Of<M,A>, val2:Of<M,B>):Of<M,A> return mz.thenLeft(val1, val2)

  // delegation Monad
  
  public inline function flatMap<A,B>(val:Of<M,A>, f: A->Of<M,B>):Of<M,B> return mz.flatMap(val,f)
  
  public inline function flatten <A> (val: Of<M, Of<M,A>>):Of<M,A> return mz.flatten(val)
  
}