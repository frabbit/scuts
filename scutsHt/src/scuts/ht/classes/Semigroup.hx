package scuts.ht.classes;


/**
 * A Semigroup can append two values returning a combined value with the same type. 
 */
interface Semigroup<A>  
{
  /**
   * Appends a1 and a2 together.
   */
  public function append (a1:A, a2:A):A;
}