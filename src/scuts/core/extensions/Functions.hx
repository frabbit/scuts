package scuts.core.extensions;


import scuts.core.types.Option;
import scuts.core.types.Either;
import scuts.core.types.Tup2;
import scuts.core.types.Tup3;
using scuts.core.extensions.Options;

class Function0s 
{
  public static function tryToOption <T>(f:Void->T):Void->Option<T>
  {
    return function () return try Some(f()) catch (e:Dynamic) None;
  }
  
  public static function evalToOption <T>(f:Void->T):Option<T>
  {
    return try Some(f()) catch (e:Dynamic) None;
  }
  
  public static function toEffect <T>(f:Void->T):Void->Void
  {
    return function () f();
  }
  
  public static function lazyThunk <X>(f:Void->X):Void->X
  {
    var cur = None;
    return function () {
      return switch (cur) {
        case Some(x): x;
        case None: 
          var x = f();
          cur = Some(x);
          x;
      }
    }
  }
  
  public static function promote <T,X>(f:Void->T):X->T
  {
    return function (x) return f();
  }
  
  /*
   * macro stuff
   * 
  public static function tryToEither <T,X,Y>(f:Void->T, handler:X->Y):Void->Either<Y, T>
  {
    return function () return try Right(f()) catch (e:X) Left(handler(e));
  }
  
  public static function evalToEither <T,X,Y>(f:Void->T, handler:X->Y):Either<Y, T>
  {
    return try Right(f()) catch (e:X) Left(handler(e));
  }
  */
  
}


// TODO: A Macro would be nice, something like F.compose( a, b, c ) with optimizations, auto-currying and short lambdas.
// Maybe something like a functional context: F.ctx (' a( b . c . f.flip() . x => x + 1 * _+2 ')(d)
class Function1s 
{
  /**
   * Composes 2 Functions together. 
   * 
   * f1.compose(f2)(x) := f1(f2(x))
   * 
   * usage:
   *   var f1:Int->String = ...
   *   var f2:Float->Int = ...
   *   var g:Float->String = f1.compose2(f2);
   */
  public static function compose < A, B, C > (f1:B->C, f2:A->B):A->C
  {
    return function (a:A) return f1(f2(a));
  }
  
  /**
   * Composes 2 Functions by currying the second function A->B->C to A->(B->C).
   * (B->C) must be the first Argument of f1.
   * 
   * usage:
   *   var f1:(Int->Int)->Int = ...
   *   var f2:String->Int->Int = ...
   *   var g:String->Int = f1.compose2(f2);
   */
  public static function compose2 < A, B, C,D > (f1:(B->C)->D, f2:A->B->C):A->D
  {
    var f2Curried = function (a) return function (b:B) return f2(a,b);
    return compose(f1, f2Curried);
  }
  
  /**
   * Composes 2 Functions by currying the second function A->B->C->D to A->(B->C->D).
   * (B->C->D) must be the first Argument of f1.
   * 
   * usage:
   *   var f1:(Int->Int->Int)->Int = ...
   *   var f2:String->Int->Int->Int = ...
   *   var g:String->Int = f1.compose3(f2);
   */
  public static function compose3 <A,B,C,D,E> (f1:(B->C->D)->E, f2:A->B->C->D):A->E
  {
    var f2Curried = function (a) return function (b:B, c:C) return f2(a,b,c);
    
    return compose(f1, f2Curried);
  }
  
  public static function compose4 <A,B,C,D,E,F> (f1:(B->C->D->E)->F, f2:A->B->C->D->E):A->F
  {
    var f2Curried = function (a) return function (b:B, c:C,d:D) return f2(a,b,c,d);
    
    return compose(f1, f2Curried);
  }
  
  public static function toEffect <T,X>(f:X->T):X->Void
  {
    return function (x) f(x);
  }
  
  /*
  public static function compose2 < A, B, C, D > (f2:C->D, f1:A->B->C):A->B->D
  {
    return function (a:A, b:B) return f2(f1(a, b));
  }
  public static function compose3 < A, B, C, D, E > (f2:D->E, f1:A->B->C->D):A->B->C->E
  {
    return function (a:A, b:B, c:C) return f2(f1(a, b, c));
  }
  public static function compose4 < A, B, C, D, E, F > (f2:E->F, f1:A->B->C->D->E):A->B->C->D->F
  {
    return function (a:A, b:B, c:C, d:D) return f2(f1(a, b, c, d));
  }
  public static function compose5 < A, B, C, D, E, F, G > (f2:F->G, f1:A->B->C->D->E->F):A->B->C->D->E->G
  {
    return function (a:A, b:B, c:C, d:D, e:E) return f2(f1(a, b, c, d, e));
  }
  */
  
}

class Function2s 
{
  public static function curry < A, B, C > (f:A->B->C):A->(B->C)
  {
    return function (a:A) 
      return function (b:B) return f(a, b);
  }

  public static function uncurry <A,B,C>(f:A->(B->C)):A->B->C
  {
    return function (a:A, b:B) return f(a)(b);
  }
  
  public static function flip < A, B, C > (f:A->B->C):B->A->C
  {
    return function (b, a) return f(a, b);
  }

  public static function tupled <A,B,Z>(f:A->B->Z):Tup2<A,B>->Z
  {
    return function (t) return f(t._1, t._2);
  }
  public static function untupled <A,B,Z>(f:Tup2<A,B>->Z):A->B->Z
  {
    return function (a,b) return f(Tup2.create(a,b));
  }
}

class Function3s 
{

  public static function curry < A, B, C, D > (f:A->B->C->D):A->(B->(C->D))
  {
    return function (a:A) 
      return function (b:B) 
        return function(c:C) return f(a, b, c);
  }
  
  public static function uncurry <A,B,C,D>(f:A->(B->(C->D))):A->B->C->D
  {
    return function (a,b,c) return f(a)(b)(c);
  }
  
  public static function flip < A, B, C, D > (f:A->B->C->D):B->A->C->D
  {
    return function (b, a, c) return f(a, b, c);
  }
  
  public static function tupled <A,B,C,Z>(f:A->B->C->Z):Tup3<A,B,C>->Z
  {
    return function (t) return f(t._1, t._2, t._3);
  }
  
  public static function untupled <A,B,C,Z>(f:Tup3<A,B,C>->Z):A->B->C->Z
  {
    return function (a,b,c) return f(Tup3.create(a,b,c));
  }

}

class Function4s 
{

  public static function curry < A, B, C, D, Z > (f:A->B->C->D->Z):A->(B->(C->(D->Z)))
  {
    return function (a:A) 
      return function (b:B) 
        return function(c:C) 
          return function(d:D) 
            return f(a, b, c,d);
  }

  public static function uncurry <A,B,C,D, Z>(f:A->(B->(C->(D->Z)))):A->B->C->D->Z
  {
    return function (a,b,c,d) return f(a)(b)(c)(d);
  }
  
  public static function flip < A, B, C, D, E > (f:A->B->C->D->E):B->A->C->D->E
  {
    return function (b, a, c, d) return f(a, b, c, d);
  }
  
}
class Function5s 
{

  public static function flip < A, B, C, D, E, F > (f:A->B->C->D->E->F):B->A->C->D->E->F
  {
    return function (b, a, c, d, e) return f(a, b, c, d, e);
  }
  
}