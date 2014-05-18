package scuts.ht.classes;


import scuts.core.Ordering;


interface Ord<T> extends Eq<T>
{
  /**
   * Compares a and b and returns the result as a Ordering Type.
   */
  public function compare (a:T, b:T):Ordering;

  /**
   * Returns true if a is less then b.
   */
  public function less (a:T, b:T):Bool;

  /**
   * Returns true if a is less then b or if they are equal.
   */
  public function lessOrEq (a:T, b:T):Bool;

  /**
   * Returns true if a is greater then b or if they are equal.
   */
  public function greaterOrEq (a:T, b:T):Bool;

  /**
   * Returns true if a is greater then b.
   */
  public function greater (a:T, b:T):Bool;


  /**
   * Returns the minimum of a and b.
   */
  public function min (a:T, b:T):T;

  /**
   * Returns the maximum of a and b.
   */
  public function max (a:T, b:T):T;


}

