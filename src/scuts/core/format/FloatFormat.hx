package scuts.core.format;

/**
 * ...
 * @author 
 */

class FloatFormat 
{

  public static function toPrecision(f:Float, precision:Int):String
  {
    var factor = Math.pow(10, precision);
    var t = Math.round(f * factor);
    
    var s = Std.string(t / factor);
    
    if (s.indexOf(".") == -1) s += ".";
    
    while (s.indexOf(".") > s.length - precision - 1) s += "0";
    
    return s;
    
  }
  
}