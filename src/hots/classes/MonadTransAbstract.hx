package hots.classes;

import hots.COf;
import hots.Of;
import scuts.Scuts;

import hots.classes.Monad;

// Monad Transformer
@:tcAbstract class MonadTransAbstract<T> implements MonadTrans<T>  {
  
  
  public function lift <M,A>(a:Of<M,A>, m:Monad<M>):COf<T,M,A> return Scuts.abstractMethod() 
  
}
