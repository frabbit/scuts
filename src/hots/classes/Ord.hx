package hots.classes;


import scuts.core.Ordering;


interface Ord<T> implements Eq<T> 
{
  
  /**
   * Compares a and b and returns the result as a Ordering Type.
   */
  public function compare (a:T, b:T):Ordering;
  
  /**
   * Same as compare, but returns the comparison result as an int where:
   * 
   * < -1 means smaller
   * 0    means equal
   * >  1 means greater
   * 
   * This function was added to provide a comparision 
   * function for other Haxe functions that expects this form.
   */
  public function compareInt (a:T, b:T):Int;
  
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

