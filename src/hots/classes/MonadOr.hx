package hots.classes;
import hots.Of;
import scuts.Scuts;

/**
 * ...
 * @author 
 */




interface MonadOr<M> implements MonadEmpty<M>
{
  public function orElse <A>(val1:Of<M,A>, val2:Of<M,A>):Of<M,A>;
}