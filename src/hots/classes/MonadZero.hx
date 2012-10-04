package hots.classes;

import hots.Of;
import scuts.Scuts;

/**
 * MonadZero adds the abbility to provide a zero value to a Monad.
 */
interface MonadZero<M> implements Monad<M>
{
  /**
   * A zero value in the kontext m.
   */
  public function zero <A>():Of<M,A>;
  
}