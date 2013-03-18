package scuts.ht.classes;

import scuts.ht.core.Of;
import scuts.Scuts;

/**
 * MonadZero adds the abbility to provide a zero value to a Monad.
 */
interface MonadEmpty<M> extends Monad<M> extends Empty<M>
{
  
}