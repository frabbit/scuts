package scuts.core.extensions;



class Predicate2Ext 
{

  public static function and <A,B>(f1:A->B->Bool, f2:A->B->Bool):A->B->Bool
  {
    return function (a,b) return f1(a,b) && f2(a,b);
  }
  
  public static function not <A,B>(f:A->B->Bool):A->B->Bool
  {
    return function (a,b) return !f(a,b);
  }
  
  public static function or  <A,B>(f1:A->B->Bool, f2:A->B->Bool):A->B->Bool
  {
    return function (a,b) return f1(a,b) || f2(a,b);
  }
 
  
}