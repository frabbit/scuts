package scuts.core;

class Ints 
{

  
  public static inline  function plus(a:Int, b:Int):Int return a + b;
  public static inline  function minus(a:Int, b:Int):Int return a - b;
  public static inline  function multiply(a:Int, b:Int):Int return a * b;
  
  public static inline  function divide(a:Int, b:Int):Float return a / b;

  public static inline  function div(a:Int, b:Int):Int return Std.int(a / b);

  public static inline  function eq(a:Int, b:Int):Bool return a == b;
  
  public static inline function max(a:Int, b:Int) return a > b ? a : b;
  
  public static inline function min(a:Int, b:Int) return a < b ? a : b;
  
  public static inline function inRange(i:Int, min:Int, maxExcluded:Int) return i >= min && i < maxExcluded;
  
  
  
  
}