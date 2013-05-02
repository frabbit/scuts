package scuts.core;



class Floats
{
  
  public static inline var EPSILON = 1e-5;
  
  public static inline function eq(a:Float, b:Float):Bool 
  {
    var diff = a - b;
    
    return (diff >= 0.0 && diff < EPSILON)
        || (diff <= 0.0 && diff > -EPSILON);
  }
  
  public static inline function max(a:Float, b:Float) return a > b ? a : b;
  
  public static inline function min(a:Float, b:Float) return a < b ? a : b;
  
  public static inline function round(v:Float) return Math.round(v);
  
  public static inline function ceil(v:Float) return Math.ceil(v);
  
  public static inline function floor(v:Float) return Math.floor(v);
  
  public static inline function abs(v:Float) return Math.abs(v);

  public static inline  function plus(a:Float, b:Float):Float return a + b;
  public static inline  function minus(a:Float, b:Float):Float return a - b;
  public static inline  function multiply(a:Float, b:Float):Float return a * b;
  
  public static inline  function divide(a:Float, b:Float):Float return a / b;
  
  public static function formatToPrecision(f:Float, precision:Int):String
  {
    var factor = Math.pow(10, precision);
    var t = Math.round(f * factor);
    
    var r = (t/factor);
    var s = Std.string(r);
    var eReg = ~/^([1-9]+)e-([0-9]{1,3})$/;
    var s = if (eReg.match(s)) {
      var divident = Std.parseInt(eReg.matched(1));
      var divisor = Std.parseInt(eReg.matched(2));
      s = "0.";
      for (i in 0...divisor-1) s +="0";
      s += divident;
      s;
    } else s;
    
    if (s.indexOf(".") == -1) s += ".";
    
    while (s.indexOf(".") > s.length - precision - 1) s += "0";
    
    return s;
    
  }
}