package hots.classes;

import scuts.Scuts;



interface Monoid<A> implements Semigroup<A>
{
  /**
   * Returns an appropriate zero value.
   */
  public function empty ():A;
}

