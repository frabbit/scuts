package scuts.core;
import scuts.core.Option;
import scuts.core.Tup2;
import scuts.core.Unit;
import scuts.core.Either;

using scuts.core.Options;

class OptionPredicates0 {
  
}

class OptionPredicates1 {
  
}

class OptionPredicates2 
{
  public static function not <A,B,X>(f:A->B->Option<X>):A->B->Option<Unit> 
  {
    return function (a,b) return f(a,b).ifNone(function () return Some(Unit), Options.none);
  }
  
  public static function map <A,B,X,Y>(f:A->B->Option<X>, mapper:X->Y):A->B->Option<Y> 
  {
    return function (a,b) return f(a,b).map(mapper);
  }
  
  public static function or <A,B,X,Y>(f1:A->B->Option<X>, f2:A->B->Option<Y>):A->B->Option<Unit> 
  {
    return function (a,b) return if (f1(a,b).isSome() || f2(a,b).isSome()) Some(Unit) else None;
  }
  
  
  
  public static function andSecond <A,B,X,Y>(f1:A->B->Option<X>, f2:A->B->Option<Y>):A->B->Option<Y> 
  {
    return function (a,b) return if (f1(a,b).isSome()) f2(a,b) else None;
  }
  
  public static function andFirst <A,B,X,Y>(f1:A->B->Option<X>, f2:A->B->Option<Y>):A->B->Option<X> 
  {
    return function (a,b) return if (f2(a,b).isSome()) f1(a,b) else None;
  }
  
  public static function and <A,B,X,Y>(f1:A->B->Option<X>, f2:A->B->Option<Y>):A->B->Option<Tup2<X,Y>> 
  {
    return zip(f1,f2);
  }
  
  public static function zip <A,B,X,Y>(f1:A->B->Option<X>, f2:A->B->Option<Y>):A->B->Option<Tup2<X,Y>> 
  {
    return zipWith(f1,f2,Tup2.create);
  }
  
  public static function zipWith <A,B,X,Y,Z>(f1:A->B->Option<X>, f2:A->B->Option<Y>, zipper:X->Y->Z):A->B->Option<Z> 
  {
    return function (a,b) return f1(a,b).zipWith(f2(a,b), zipper);
  }
}