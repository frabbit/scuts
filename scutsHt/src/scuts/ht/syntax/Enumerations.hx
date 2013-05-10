
package scuts.ht.syntax;

import scuts.ds.LazyLists;
import scuts.ht.classes.Enumeration;

class Enumerations 
{
  public static inline function pred <T>(a:T, e : Enumeration<T>):T return e.pred(a);
  
  public static inline function succ <T>(a:T, e : Enumeration<T>):T return e.succ(a);
  
  public static inline function toEnum <T>(i:Int, e : Enumeration<T>):T return e.toEnum(i);

  public static inline function fromEnum <T>(i:T, e : Enumeration<T>):Int return e.fromEnum(i);
  
  public static inline function enumFrom <T>(a:T, e : Enumeration<T>):LazyList<T> return e.enumFrom(a);
  
  public static inline function enumFromTo <T>(a:T, b:T, e : Enumeration<T>):LazyList<T> return e.enumFromTo(a, b);
  
  public static inline function enumFromThenTo <T>(a:T, b:T, c:T, e : Enumeration<T>):LazyList<T> return e.enumFromThenTo(a, b, c);

}