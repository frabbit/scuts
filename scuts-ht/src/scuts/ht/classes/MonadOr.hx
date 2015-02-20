package scuts.ht.classes;
import scuts.Scuts;

/**
 * ...
 * @author
 */




interface MonadOr<M> extends MonadEmpty<M>
{
  public function orElse <A>(val1:M<A>, val2:M<A>):M<A>;
}