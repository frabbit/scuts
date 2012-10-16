package scuts.core;

import scuts.core.Option;
import scuts.Scuts;

class Strings
{
 
  /**
   * Concatenates the string s with itself t times.
   */
  public static function times (s:String, t:Int) 
  {
    var b = new StringBuf();
    while (t-- > 0) b.add(s);
    return b.toString();
  }
  
  /**
   * Trims surrounding whitespace of a string.
   */
  public static inline function trim (s:String) return StringTools.trim(s)
  
  /**
   * Trims surrounding whitespace from the left side of a string.
   */
  public static inline function trimLeft (s:String) return StringTools.ltrim(s)
  
  /**
   * Trims surrounding whitespace from the right side of a string.
   */
  public static inline function trimRight (s:String) return StringTools.rtrim(s)
  
  /**
   * Pads the string c from the left to string s while the length of s is smaller than length.
   */
  public static inline function padLeft (s:String, c:String, length:Int) return StringTools.lpad(s, c, length)
  
  /**
   * Pads the string c from the right to string s while the length of s is smaller than length.
   */
  public static inline function padRight (s:String, c:String, length:Int) return StringTools.rpad(s, c, length)
  
  /**
   * Adds the indent s to each line of s.
   */
  public static inline function indent (s:String, indent:String) 
  {
    return indent + s.split("\n").join("\n" + indent);
  }
  
  /**
   * Removes the indent s from each line of s, if possible.
   */
  public static function unindent (s:String, indent:String) 
  {
    if (startsWith(s, indent)) s = s.substr(indent.length);
    return s.split("\n" + indent).join("\n");
  }
  
  /**
   * Converts the string s into an Int if possible.
   */
  public static function toInt(s:String):Option<Int>
  {
    var i = Std.parseInt(s);
    return if (i != null) Some(i) else None;
  }
  
  /**
   * Converts the string s into an Float if possible.
   */
  public static function toFloat(s:String):Option<Float>
  {
    var i:Null<Float> = Std.parseFloat(s);
    return if (i != null) Some(i) else None;
  }
  
  /**
   * Returns true if s starts with start.
   */
  public static inline function startsWith(s:String, start:String) 
  {
    return StringTools.startsWith(s, start);
  }
  
  /**
   * Returns true if s ends with end.
   */
  public static inline function endsWith(s:String, end:String):Bool 
  {
    return StringTools.endsWith(s, end);
  }
  
  /**
   * Replace each occurrence of sub in s with by.
   */
  public static inline function replace(s:String, sub:String, by:String):String 
  {
    return StringTools.replace(s, sub, by);
  }
  
  /**
   * Replace each match of pattern in s with by.
   */
  public static inline function replaceEReg(s:String, pattern:EReg, by:String):String 
  {
    return pattern.replace(s, by);
  }
  
  /**
   * Counts the number of occurences of sub in s.
   */
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
  
  /**
   * Compares two strings for equality.
   */
  public static inline function eq(s1:String, s2:String):Bool {
    return s1 == s2;
  }
  
  /**
   * Splits the string s into its lines. All occurences of \r are removed.
   */
  public static function lines(s:String):Array<String> {
    return s.split("\r").join("").split("\n");
  }
  
  /**
   * Turns an list of strings into a String by concatenating the strings with newlines (\n).
   */
  public static function unlines(lines:Array<String>):String {
    return lines.join("\n");
  }
  
  /**
   * Turns the string s into its words, splitting is done on each whitespace occurence between words.
   */
  public static function words(s:String):Array<String> {
    return ~/([\r][\n])|[ \n\t]/.split(s);
  }
  
  /**
   * Turns the list of words s into a string by concatenating the strings with a space.
   */
  public static function unwords(s:Array<String>):String {
    return s.join(" ");
  }
  
  
}