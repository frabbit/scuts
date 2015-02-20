package scuts.ht.classes;
import scuts.Scuts;


/**
   * Adds an appending operation to a monad zero,
   * append combines to monadic values into one.
   * MonadPlus is like a Monad and a Monoid in one type.
   */
interface MonadPlus<M> extends MonadEmpty<M> extends Plus<M>
{

  /**
   * Appends two monadic values, val1 and val2.
   */
  public function plus <A>(a:M<A>, b:M<A>):M<A>;
}