package hots.classes;

import hots.COf;
import hots.Of;
import hots.wrapper.Mark;
import hots.wrapper.MTVal;
import hots.wrapper.MVal;
import scuts.Scuts;

import hots.classes.Monad;

// Monad Transformer
@:tcAbstract class MonadTransAbstract<T>  {
  
  public function lift <A>(a:Of<M,A>, m:Monad<M>):COf<T,M,A> Scuts.abstractMethod() 
  
}

/*
class MonadTDefault<T> {
  
  var monad:Monad<M1>;
  
  public function new (functor:FunctorT<M1, M2>, outerMonad:Monad<M1>) {
    super(functor);
    this.outerMonad = outerMonad;
  }
  
  override public function ret <A>(a:A):MTVal<M1,M2,A> 
  {
    return lift(outerMonad.ret(a));
  }
  
  
  
  public function lift <A>(a:MVal<M1,A>):MTVal<M1,M2,A> { throw "abstract"; return null;}
  //public function unlift <C>(a:MT<A,B,C> ):M<B,C> { throw "abstract"; return null;}
  
}
*/