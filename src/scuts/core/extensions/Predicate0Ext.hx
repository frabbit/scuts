package scuts.core.extensions;

class Predicate0Ext 
{

  public static function and (f1:Void->Bool, f2:Void->Bool):Void->Bool
  {
    return function () return f1() && f2();
  }
  
  public static function not (f:Void->Bool):Void->Bool
  {
    return function () return !f();
  }
  
  public static function or  (f1:Void->Bool, f2:Void->Bool):Void->Bool
  {
    return function () return f1() || f2();
  }
  
}