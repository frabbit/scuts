package hots.classes;

import hots.instances.OptionTOf;
import hots.OfOf;
import hots.Of;
import hots.classes.Monad;
import scuts.core.types.Option;


// Monad Transformer
interface MonadTrans<T>  {
  
  public function optionT <M,A>(a:Of<M,Option<A>>):OptionTOf<M,A>; 
  public function runOptionT <M,A>(a:OptionTOf<M,A>):OfOf<T,M,A>; 
  
}
