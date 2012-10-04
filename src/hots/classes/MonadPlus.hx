package hots.classes;
import hots.classes.MonadZero;
import hots.Of;
import scuts.Scuts;


/**
   * Adds an appending operation to a monad zero,
   * append combines to monadic values into one.
   * MonadPlus is like a Monad and a Monoid in one type.
   */
interface MonadPlus<M> implements MonadZero<M>
{
  
  /**
   * Appends two monadic values, val1 and val2.
   */
  public function append <A>(val1:Of<M,A>, val2:Of<M,A>):Of<M,A>;
}