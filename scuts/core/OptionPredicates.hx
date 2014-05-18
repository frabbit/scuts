package scuts.core;

import scuts.core.Tuples;
import scuts.core.Unit;
import scuts.core.Eithers.Either;

using scuts.core.Options;

using scuts.core.Functions;

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

  public static function orEither <A,B,X,Y>(f1:A->B->Option<X>, f2:A->B->Option<Y>):A->B->Option<Either<X,Y>> 
  {
    return orWith(f1, f2, Left, Right);
  }

  public static function orWith <A,B,X,Y,Z>(f1:A->B->Option<X>, f2:A->B->Option<Y>, w1:X->Z, w2:Y->Z):A->B->Option<Z> 
  {
    return function (a,b) return switch f1(a,b) 
    {
      case Some(x1): Some(w1(x1));
      case None: switch (f2(a,b)) {
        case Some(x2): Some(w2(x2));
        case None: None;
      }
    };

  }
  
  public static inline function andSecond <A,B,X,Y>(f1:A->B->Option<X>, f2:A->B->Option<Y>):A->B->Option<Y> 
  {
    return zipWith(f1, f2, Tup2s.second.untupled());
  }
  
  public static inline function andFirst <A,B,X,Y>(f1:A->B->Option<X>, f2:A->B->Option<Y>):A->B->Option<X> 
  {
    return zipWith(f1, f2, Tup2s.first.untupled());
  }
  
  public static inline function and <A,B,X,Y>(f1:A->B->Option<X>, f2:A->B->Option<Y>):A->B->Option<Tup2<X,Y>> 
  {
    return zip(f1,f2);
  }

  public static inline function andWith <A,B,X,Y,Z>(f1:A->B->Option<X>, f2:A->B->Option<Y>, combine:X->Y->Z):A->B->Option<Z> 
  {
    return zipWith(f1,f2, combine);
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