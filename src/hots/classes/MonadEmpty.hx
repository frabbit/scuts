package hots.classes;

import hots.Of;
import scuts.Scuts;

/**
 * MonadZero adds the abbility to provide a zero value to a Monad.
 */
interface MonadEmpty<M> implements Monad<M>, implements Empty<M>
{
  
}