package scuts1.classes;


interface Eq<T> 
{
  /**
   * Checks if a and b are equal.
   */
  public function eq (a:T, b:T):Bool;
  
  /**
   * Checks if a and b are not equal.
   */
  public function notEq (a:T, b:T):Bool;
}

