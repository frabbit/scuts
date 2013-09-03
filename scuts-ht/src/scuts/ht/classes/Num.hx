package scuts.ht.classes;
import scuts.ht.classes.Eq;
import scuts.ht.classes.Show;



interface Num<A> extends Eq<A> extends Show<A>
{
  // functions of num
  
  /**
   * (+) sum of two values
   */
  public function plus (a:A, b:A):A;
  
  /**
   * (*) multiplication of two values
   */
  public function mul (a:A, b:A):A;
  
  /**
   *  minus operation for two values
   */
  public function minus (a:A, b:A):A;
  
  /**
   *  negation of a value
   */
  public function negate (a:A):A;
  
  /**
   *  the absolut value of a
   */
  public function abs (a:A):A;
  
  /**
   *  return -1 for negative, 0 for zero and 1 for positive numbers
   */
  public function signum (a:A):A;
  /**
   * Conversion from an Integer
   */
  public function fromInt (a:Int):A;
  
}
