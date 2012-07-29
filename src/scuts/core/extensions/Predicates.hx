package scuts.core.extensions;

class Predicates0 
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

class Predicates1
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

class Predicates2 
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