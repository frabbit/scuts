package hots.classes;

import hots.classes.Monad;
import hots.Of;
import scuts.Scuts;


interface MonadFail<M> implements Monad<M> {
  
  // functions
  public function fail <A>(s:String):Of<M,A> return Scuts.abstractMethod()
  
  
}
