package scuts.core;

class Ints 
{

  
  public static inline  function eq(a:Int, b:Int):Bool return a == b;
  
  public static inline function max(a:Int, b:Int) return a > b ? a : b;
  
  public static inline function min(a:Int, b:Int) return a < b ? a : b;
  
  public static inline function inRange(i:Int, min:Int, maxExcluded:Int) return i >= min && i < maxExcluded;
  
  
  
  
}