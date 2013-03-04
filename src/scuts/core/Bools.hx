package scuts.core;


class Bools 
{
  public static inline function eq(v1:Bool, v2:Bool) return v1 == v2;
  
  public static inline function and(v1:Bool, v2:Bool) return v1 && v2;
  public static inline function or(v1:Bool, v2:Bool) return v1 || v2;
  public static inline function not(v:Bool) return !v;
}