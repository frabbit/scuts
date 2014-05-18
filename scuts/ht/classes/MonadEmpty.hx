package scuts.ht.classes;


/**
 * MonadZero adds the abbility to provide a zero value to a Monad.
 */
interface MonadEmpty<M> extends Monad<M>
{
  public function empty <A>():Of<M,A>;
}