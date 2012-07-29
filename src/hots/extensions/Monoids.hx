package hots.extensions;
import hots.classes.Monoid;

/**
 * ...
 * @author 
 */

class Monoids 
{

  public static inline function append <T>(v1:T, v2:T, m:Monoid<T>):T {
    return m.append(v1, v2);
  }
  
}