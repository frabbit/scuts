package scuts.core.format;
import scuts.core.debug.Assert;


class StringFormat 
{

  public static function fillLeft(s:String, newLength:Int, fillChar:String = " ") 
  {
    Assert.isTrue(fillChar.length == 1);
    
    while (s.length < newLength) s = fillChar + s;
    
    return s;
  }
  
  public static function fillRight(s:String, newLength:Int, fillChar:String = " ") 
  {
    Assert.isTrue(fillChar.length == 1);
    
    while (s.length < newLength) s = s + fillChar;
    
    return s;
  }
  
}