package scuts.core.extensions;
import scuts.core.math.MathConstants;

/**
 * ...
 * @author 
 */

class Floats
{
  public static inline function eq(a:Float, b:Float):Bool 
  {
    var diff = a - b;
    
    return (diff >= 0.0 && diff < MathConstants.EPSILON)
        || (diff <= 0.0 && diff > -MathConstants.EPSILON);
  }
  
  public static inline function max(a:Float, b:Float) return a > b ? a : b
  
  public static inline function min(a:Float, b:Float) return a < b ? a : b
  
  public static inline function round(v:Float) return Math.round(v)
  
  public static inline function ceil(v:Float) return Math.ceil(v)
  
  public static inline function floor(v:Float) return Math.floor(v)
  
  public static inline function abs(v:Float) return Math.abs(v)
  
}