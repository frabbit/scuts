package scuts.core.extensions;

class Predicate1Ext 
{

  public static function and < T > (f1:T->Bool, f2:T->Bool):T->Bool
  {
    return function (a) return f1(a) && f2(a);
  }
  
  public static function not < T > (f:T->Bool):T->Bool
  {
    return function (a) return !f(a);
  }
  
  public static function or < T > (f1:T->Bool, f2:T->Bool):T->Bool
  {
    return function (a) return f1(a) || f2(a);
  }
  
}