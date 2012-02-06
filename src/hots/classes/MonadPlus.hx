package hots.classes;
import hots.classes.MonadZero;
import hots.Of;
import scuts.Scuts;



interface MonadPlus<M> implements MonadZero<M>
{
      
  public function append <A>(val1:Of<M,A>, val2:Of<M,A>):Of<M,A>;
  
  
}