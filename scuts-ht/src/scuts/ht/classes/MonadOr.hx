package scuts.ht.classes;
import scuts.ht.core.Of;
import scuts.Scuts;

/**
 * ...
 * @author 
 */




interface MonadOr<M> extends MonadEmpty<M>
{
  public function orElse <A>(val1:Of<M,A>, val2:Of<M,A>):Of<M,A>;
}