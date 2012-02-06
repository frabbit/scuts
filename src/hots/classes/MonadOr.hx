package hots.classes;
import hots.classes.MonadZero;
import hots.wrapper.MVal;
import scuts.Scuts;

/**
 * ...
 * @author 
 */




interface MonadOr<M> implements MonadZero<M>
{
  public function orElse <A>(val1:MVal<M,A>, val2:MVal<M,A>):MVal<M,A> return Scuts.abstractMethod()
}