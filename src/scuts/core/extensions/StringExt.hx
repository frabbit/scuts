package scuts.core.extensions;

import scuts.Scuts;

class StringExt
{
 
  public static function times (s:String, t:Int) 
  {
    var b = new StringBuf();
    while (t-- > 0) b.add(s);
    return b.toString();
  }
  
  public static inline function trim (s:String) return StringTools.trim(s)
  
  public static inline function trimLeft (s:String) return StringTools.ltrim(s)
  
  public static inline function trimRight (s:String) return StringTools.rtrim(s)
  
  public static inline function padLeft (s:String, c:String, length:Int) return StringTools.lpad(s, c, length)
  
  public static inline function padRight (s:String, c:String, length:Int) return StringTools.rpad(s, c, length)
  
  public static inline function indent (s:String, indent:String) 
  {
    return indent + s.split("\n").join("\n" + indent);
  }
  
  public static function unindent (s:String, indent:String) 
  {
    if (startsWith(s, indent)) s = s.substr(indent.length);
    return s.split("\n" + indent).join("\n");
  }
  
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
  
  public static inline function replace(s:String, sub:String, by:String):String 
  {
    return StringTools.replace(s, sub, by);
  }
  
  public static inline function replaceEReg(s:String, ereg:EReg, by:String):String 
  {
    return ereg.replace(s, by);
  }
  
  public static function countSub(s:String, sub:String):Int 
  {
    var i = 0;
    var count = 0;
    while (true) 
    {
      var i = s.indexOf(sub, i);
      if (i != -1)
        count++;
      else
        break;
    }
    return count;
  }
  
  public static inline function eq(s1:String, s2:String):Bool {
    return s1 == s2;
  }
  
  
}