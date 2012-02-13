package hots.classes;

import hots.COf;
import hots.Of;
import hots.classes.Monad;
import hots.TC;

// Monad Transformer
interface MonadTrans<T> implements TC {
  
  public function lift <M,A>(a:Of<M,A>, m:Monad<M>):COf<T,M,A>; 
  
}
