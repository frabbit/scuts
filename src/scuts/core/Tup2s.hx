package scuts.core;
import scuts.core.Tup2;

class Tup2s 
{
  /**
   * Swaps the values of a tuple.
   * 
   * Tup2.create(1,2).swap(); // (2,1)
   */
  public static function swap <A,B>(t:Tup2<A,B>) return Tup2.create(t._2, t._1)
  
  public static function first  <A,B>(t:Tup2<A,B>) return t._1
  public static function second <A,B>(t:Tup2<A,B>) return t._2
  
  /**
   * Compares two tuples for equality based on equal functions for the parameter types.
   */
  public static function eq <A,B>(t1:Tup2<A,B>, t2:Tup2<A,B>, eq1:A->A->Bool, eq2:B->B->Bool) {
    return eq1(t1._1, t2._1) && eq2(t1._2, t2._2);
  }
}