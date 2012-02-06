package hots.classes;

import hots.COf;
import hots.Of;
import hots.classes.Monad;

// Monad Transformer
class MonadTrans<T>  {
  
  public function lift <A>(a:Of<M,A>, m:Monad<M>):COf<T,M,A>; 
  
}
