package hots.extensions;
import hots.classes.Ord;
import scuts.core.types.Ordering;


class OrdExt 
{

  public static inline function compare<T>(v1:T, v2:T, o:Ord<T>):Ordering return o.compare(v1, v2)
    
  public static inline function greater<T>(v1:T, v2:T, o:Ord<T>):Bool return o.greater(v1, v2)
  
  public static inline function less<T>(v1:T, v2:T, o:Ord<T>):Bool return o.less(v1, v2)
  
  public static inline function greaterOrEq<T>(v1:T, v2:T, o:Ord<T>):Bool return o.greaterOrEq(v1, v2)
  
  public static inline function lessOrEq<T>(v1:T, v2:T, o:Ord<T>):Bool return o.lessOrEq(v1, v2)
  
  public static inline function max<T>(v1:T, v2:T, o:Ord<T>):T return o.max(v1, v2)
  
  public static inline function min<T>(v1:T, v2:T, o:Ord<T>):T return o.min(v1, v2)
  
}