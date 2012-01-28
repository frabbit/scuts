package scuts.core.extensions;

import scuts.Scuts;

class Strings 
{
  public static inline function toInt(s:String):Int 
  {
    var i = Std.parseInt(s);
    return if (i != null) i else Scuts.error("Cannot convert " + s + " to Int");
  }
  
  public static inline function toFloat(s:String):Float
  {
    var i = Std.parseFloat(s);
    return if (i != null) i else Scuts.error("Cannot convert " + s + " to Int");
  }
  
  public static inline function startsWith(s:String, start:String) 
  {
    return StringTools.startsWith(s, start);
  }
  
  public static inline function endsWith(s:String, end:String):Bool 
  {
    return StringTools.endsWith(s, end);
  }
  
  public static inline function replace(s:String, what:String, with:String):String 
  {
    return s.split(what).join(with);
  }
  
}