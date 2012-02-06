package hots.classes;

import hots.Of;
import scuts.Scuts;



interface MonadZero<M> implements Monad<M>
{
  

  // functions
  public function zero <A>():Of<M,A>;
  
  
  
}