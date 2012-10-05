package hots.classes;
import hots.Of;
import scuts.Scuts;


/**
   * Adds an appending operation to a monad zero,
   * append combines to monadic values into one.
   * MonadPlus is like a Monad and a Monoid in one type.
   */
interface MonadPlus<M> implements MonadEmpty<M>, implements Plus<M>
{
  
  /**
   * Appends two monadic values, val1 and val2.
   */
  public function plus <A>(a:Of<M,A>, b:Of<M,A>):Of<M,A>;
}