package scuts.core.extensions;
import scuts.core.math.MathConstants;

/**
 * ...
 * @author 
 */

class FloatExt
{
  public static inline function eq(v1:Float, v2:Float):Bool 
  {
    var diff = a - b;
    
    return (diff >= 0.0 && diff < MathConstants.EPSILON)
        || (diff <= 0.0 && diff > -MathConstants.EPSILON);
  }
  
  public static inline function round(v:Float) 
  {
    return Math.round(v);
  }
  
  public static inline function ceil(v:Float) 
  {
    return Math.ceil(v);
  }
  
  public static inline function floor(v:Float) 
  {
    return Math.floor(v);
  }
  
}