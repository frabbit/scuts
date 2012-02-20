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
  
  public static inline function replace(s:String, what:String, by:String):String 
  {
    return s.split(what).join(by);
  }
  
  public static inline function replaceEReg(s:String, ereg:EReg, by:String):String 
  {
    return ereg.replace(s, by);
  }
  
  public static inline function countSub(s:String, sub:String):Int 
  {
    var i = 0;
    var count = 0;
    while (true) {
      var i = s.indexOf(sub, i);
      if (i != -1) {
        count++;
      } else {
        break;
      }
    }
    return count;
  }
  
}