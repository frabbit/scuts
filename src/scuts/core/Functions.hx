package scuts.core;


import haxe.PosInfos;
import scuts.core.Option;
import scuts.core.Either;
import scuts.core.Thunk;
import scuts.core.Tup2;
import scuts.core.Tup3;
using scuts.core.Options;

class Function0s 
{
  
  public static function map <A,B>(a:Thunk<A>, f:A->B):Thunk<B>
  {
    return function () return f(a());
  }
  
  public static function flatMap <A,B>(a:Thunk<A>, f:A->Thunk<B>):Thunk<B>
  {
    return function () return f(a())();
  }
  
  @:noUsing public static function pure <A>(a:A):Thunk<A>
  {
    return function () return a;
  }
  
  
  /**
   * Converts f into a effectful function with no return type.
   */
  public static function toEffect <T>(f:Thunk<T>):Void->Void
  {
    return function () f();
  }
  
  /**
   * Promotes a function taking no arguments into a one argument function
   * by simply ignoring it's argument.
   */
  public static function promote <A,R>(f:Thunk<R>):A->R
  {
    return function (x) return f();
  }
  
}

class Function1Opts 
{

  public static function _0_ < A, B, C,D > (f:?A->C):Void->C
  {
    return function () return f();
  }
}


class Function1s 
{
  public static function map <A,B,R>(f:A->B, mapper:B->R):A->R
  {
    return function (a:A) return mapper(f(a));
  }
  
  /**
   * Transform f into a function taking only one parameter and returning another function also only taking one paramter as the result.
   */
  /*
   public static function curry < A, B > (f:A->B):A->B
  {
    return f;
  }
  */
  
  /**
   * Converts a curried function into a function taking multiple arguments.
   */
  public static function uncurry <A,B>(f:A->(Void->B)):A->B
  {
    return function (a:A) return f(a)();
  }
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
   * Reversed function composition, like a unix pipe.
   */
  public static inline function next <A,B,C> (from:A->B, to:B->C):A->C
  {
    return compose(to, from);
  }
  
  /**
   * Converts f into a effectful function with no return type.
   */
  public static function toEffect <A,R>(f:A->R):A->Void
  {
    return function (x) f(x);
  }
  
  /**
   * Partially applies the function f with the first parameter and returns a thunk.
   */
  public static function _1 < A, B > (f:A->B, a:A):Thunk<B>
  {
    return function () return f(a);
  }
}

class Function2OptsPosInfos 
{
  public static function compose < A, B, C,D > (f1:B->?PosInfos->D, f2:A->B):A->D
  {
    return function (a:A) return f1(f2(a));
  }
  public static function _0_ < A, B, C,D > (f:A->?PosInfos->C):A->C
  {
    return function (a:A) return f(a);
  }
  
}

class Function2Opts 
{
  public static function compose < A, B, C,D > (f1:B->?C->D, f2:A->B):A->D
  {
    return function (a:A) return f1(f2(a));
  }
  
  public static function _0_ < A, B, C,D > (f:A->?B->C):A->C
  {
    return function (a:A) return f(a);
  }
  
  
}



class Function2s 
{
  
  public static function map <A,B,C,R>(f:A->B->C, mapper:C->R):A->B->R
  {
    return function (a:A, b:B) return mapper(f(a,b));
  }
  
  /**
   * Transform f into a function taking only one parameter and returning another function also only taking one paramter as the result.
   */
  public static function curry < A, B, C > (f:A->B->C):A->(B->C)
  {
    return function (a:A) 
      return function (b:B) return f(a, b);
  }
  
  /**
   * Converts a curried function into a function taking multiple arguments.
   */
  public static function uncurry <A,B,C>(f:A->(B->C)):A->B->C
  {
    return function (a:A, b:B) return f(a)(b);
  }
  
  /**
   * Partially applies the function f with the first parameter.
   */
  public static function _1 < A, B, C > (f:A->B->C, a:A):B->C
  {
    return function (b:B) return f(a, b);
  }
  
  /**
   * Partially applies the function f with the second parameter.
   */
  public static function _2 < A, B, C > (f:A->B->C, b:B):A->C
  {
    return function (a:A) return f(a, b);
  }
  
  /**
   * Partially applies the function f with the first and second parameter and returns a thunk.
   */
  public static function _12 < A, B, C > (f:A->B->C, a:A, b:B):Thunk<C>
  {
    return function () return f(a, b);
  }
  
  

  
  
  /**
   * Reverses the first 2 arguments of f.
   */
  public static function flip < A, B, C > (f:A->B->C):B->A->C
  {
    return function (b, a) return f(a, b);
  }

  /**
   * Converts f into a function taking a Tuple as only parameter instead of 2 values.
   */
  public static function tupled <A,B,Z>(f:A->B->Z):Tup2<A,B>->Z
  {
    return function (t) return f(t._1, t._2);
  }
  
  /**
   * Converts f into a function taking 2 parameters instead of a Tuple.
   */
  public static function untupled <A,B,Z>(f:Tup2<A,B>->Z):A->B->Z
  {
    return function (a,b) return f(Tup2.create(a,b));
  }
  
  /**
   * Converts f into a effectful function with no return type.
   */
  public static function toEffect <A,B,R>(f:A->B->R):A->B->Void
  {
    return function (a,b) f(a,b);
  }
}

class Function3Opts2PosInfos 
{
  
  public static function _0_ < A, B,C,D > (f:A->?B->?PosInfos->D):A->D
  {
    return function (a:A) return f(a);
  }
  
  public static function _1_ < A, B,C,D > (f:A->?B->?PosInfos->D, a:A):B->D
  {
    return function (b:B) return f(a,b);
  }
  
  
  
}


class Function3Opts1PosInfos 
{
  
  public static function _0_ < A, B,C,D > (f:A->B->?PosInfos->D):A->B->D
  {
    return function (a:A, b:B) return f(a,b);
  }
  
  public static function _1_ < A, B,C,D > (f:A->B->?PosInfos->D, a:A):B->D
  {
    return function (b:B) return f(a,b);
  }
  
  public static function _2_ < A, B,C,D > (f:A->B->?PosInfos->D, b:B):A->D
  {
    return function (a:A) return f(a,b);
  }
  public static function _12_ < A, B,C,D > (f:A->B->?PosInfos->D, a:A, b:B):Void->D
  {
    return function () return f(a,b);
  }
  
}

class Function3Opts3
{
  public static function _0_ < A, B, C,D > (f:?A->?B->?C->D):Void->D
  {
    return function () return f();
  }
}
class Function3Opts2
{
  public static function _0_ < A, B, C,D > (f:A->?B->?C->D):A->D
  {
    return function (a:A) return f(a);
  }
  
  public static function _1_ < A, B, C,D > (f:A->?B->?C->D, a:A):Void->D
  {
    return function () return f(a);
  }
  
  public static function compose < A, B, C,D,X > (f1:A->?B->?C->D, f2:X->A):X->D
  {
    return function (a:X) return f1(f2(a));
  }
}


class Function3Opts1
{
  public static function _0_ < A, B,C,D > (f:A->B->?C->D):A->B->D
  {
    return function (a:A, b:B) return f(a,b);
  }
  
  public static function _1_ < A, B,C,D > (f:A->B->?C->D, a:A):B->D
  {
    return function (b:B) return f(a,b);
  }
  
  public static function _2_ < A, B,C,D > (f:A->B->?C->D, b:B):A->D
  {
    return function (a:A) return f(a,b);
  }
  public static function _12_ < A, B,C,D > (f:A->B->?C->D, a:A, b:B):Void->D
  {
    return function () return f(a,b);
  }
  
}

class Function3s 
{
  /**
   * Transform f into a function taking only one parameter and returning another function also only taking one paramter as the result.
   */
  public static function curry < A, B, C, D > (f:A->B->C->D):A->(B->(C->D))
  {
    return function (a:A) 
      return function (b:B) 
        return function(c:C) return f(a, b, c);
  }
  
  /**
   * Converts a curried function into a function taking multiple arguments.
   */
  public static function uncurry <A,B,C,D>(f:A->(B->(C->D))):A->B->C->D
  {
    return function (a,b,c) return f(a)(b)(c);
  }
  /**
   * Reverses the first 2 arguments of f.
   */
  public static function flip < A, B, C, D > (f:A->B->C->D):B->A->C->D
  {
    return function (b, a, c) return f(a, b, c);
  }
  
  /**
   * Converts f into a function taking a Tuple as only parameter instead of 3 values.
   */
  public static function tupled <A,B,C,Z>(f:A->B->C->Z):Tup3<A,B,C>->Z
  {
    return function (t) return f(t._1, t._2, t._3);
  }
  
  /**
   * Converts f into a function taking 3 parameters instead of a Tuple.
   */
  public static function untupled <A,B,C,Z>(f:Tup3<A,B,C>->Z):A->B->C->Z
  {
    return function (a,b,c) return f(Tup3.create(a,b,c));
  }
  
  /**
   * Converts f into a effectful function with no return type.
   */
  public static function toEffect <A,B,C,R>(f:A->B->C->R):A->B->C->Void
  {
    return function (a,b,c) f(a,b,c);
  }
  
  /**
   * Partially applies the function f with the first parameter.
   */
  
  public static function _1 < A, B, C, D > (f:A->B->C->D, a:A):B->C->D
  {
    return function (b,c) return f(a,b,c);
  }
  
  /**
   * Partially applies the function f with the first and third parameter.
   */
    
  public static function _13 < A, B, C, D > (f:A->B->C->D, a:A, c:C):B->D
  {
    return function (b) return f(a,b,c);
  }
  
  /**
   * Partially applies the function f with the first and second parameter.
   */
    
  public static function _12 < A, B, C, D > (f:A->B->C->D, a:A, b:B):C->D
  {
    return function (c) return f(a,b,c);
  }
  
  /**
   * Partially applies the function f with the second and third parameter.
   */
    
  public static function _23 < A, B, C, D > (f:A->B->C->D, b:B, c:C):A->D
  {
    return function (a) return f(a,b,c);
  }
  
  /**
   * Partially applies the function f with the second parameter.
   */
    
  public static function _2 < A, B, C, D > (f:A->B->C->D, b:B):A->C->D
  {
    return function (a,c) return f(a,b,c);
  }
  
  /**
   * Partially applies the function f with the second parameter.
   */
    
  public static function _3 < A, B, C, D > (f:A->B->C->D, c:C):A->B->D
  {
    return function (a,b) return f(a,b,c);
  }
  
  
  
  /**
   * Partially applies the function f with the all parameter and returns a thunk.
   */
  
  
  public static function _123 < A, B, C,D > (f:A->B->C->D, a:A, b:B, c:C):Thunk<D>
  {
    return function () return f(a,b,c);
  }

}

class Function4Opt1s {
  
  /**
   * Partially applies the function f with the first, second and third parameter.
   */
  public static function _123_ < A, B, C, D, E > (f:A->B->C->?D->E, a:A, b:B, c:C):Void->E
  {
    return function () return f(a, b, c);
  }
}

class Function4s 
{

  /**
   * Transform f into a function taking only one parameter and returning another function also only taking one paramter as the result.
   */
  public static function curry < A, B, C, D, Z > (f:A->B->C->D->Z):A->(B->(C->(D->Z)))
  {
    return function (a:A) 
      return function (b:B) 
        return function(c:C) 
          return function(d:D) 
            return f(a, b, c,d);
  }

  /**
   * Converts a curried function into a function taking multiple arguments.
   */
  public static function uncurry <A,B,C,D, Z>(f:A->(B->(C->(D->Z)))):A->B->C->D->Z
  {
    return function (a,b,c,d) return f(a)(b)(c)(d);
  }
  
  /**
   * Reverses the first 2 arguments of f.
   */
  public static function flip < A, B, C, D, E > (f:A->B->C->D->E):B->A->C->D->E
  {
    return function (b, a, c, d) return f(a, b, c, d);
  }
  
  /**
   * Converts f into a effectful function with no return type.
   */
  public static function toEffect <A,B,C,D,R>(f:A->B->C->D->R):A->B->C->D->Void
  {
    return function (a,b,c,d) f(a,b,c,d);
  }
  
  /**
   * Partially applies the function f with the first parameter.
   */
  public static function _1 < A, B, C, D, E > (f:A->B->C->D->E, a:A):B->C->D->E
  {
    return function (b:B, c:C, d:D) return f(a, b, c, d);
  }
  
  /**
   * Partially applies the function f with the second parameter.
   */
  public static function _2 < A, B, C, D, E > (f:A->B->C->D->E, b:B):A->C->D->E
  {
    return function (a:A, c:C, d:D) return f(a, b, c, d);
  }
  
  /**
   * Partially applies the function f with the second parameter.
   */
  public static function _3 < A, B, C, D, E > (f:A->B->C->D->E, c:C):A->B->D->E
  {
    return function (a:A, b:B, d:D) return f(a, b, c, d);
  }
  
  /**
   * Partially applies the function f with the second parameter.
   */
  public static function _4 < A, B, C, D, E > (f:A->B->C->D->E, d:D):A->B->C->E
  {
    return function (a:A, b:B, c:C) return f(a, b, c, d);
  }
  
   /**
   * Partially applies the function f with the first and second parameter.
   */
  public static function _12 < A, B, C, D, E > (f:A->B->C->D->E, a:A, b:B):C->D->E
  {
    return function (c:C, d:D) return f(a, b, c, d);
  }
  
  /**
   * Partially applies the function f with the first, second and third parameter.
   */
  public static function _123 < A, B, C, D, E > (f:A->B->C->D->E, a:A, b:B, c:C):D->E
  {
    return function (d:D) return f(a, b, c, d);
  }
  
  /**
   * Partially applies the function f with the second parameter.
   */
  public static function _124 < A, B, C, D, E > (f:A->B->C->D->E, a:A, b:B, d:D):C->E
  {
    return function (c:C) return f(a, b, c, d);
  }
  
  /**
   * Partially applies the function f with the second parameter.
   */
  public static function _234 < A, B, C, D, E > (f:A->B->C->D->E, b:B, c:C, d:D):A->E
  {
    return function (a:A) return f(a, b, c, d);
  }
  
  /**
   * Partially applies the function f with the second parameter.
   */
  public static function _34 < A, B, C, D, E > (f:A->B->C->D->E, c:C, d:D):A->B->E
  {
    return function (a:A, b:B) return f(a, b, c, d);
  }
  
  /**
   * Partially applies the function f with the all parameter and returns a thunk.
   */
  public static function _1234 < A, B, C,D,E > (f:A->B->C->D->E, a:A, b:B, c:C, d:D):Thunk<E>
  {
    return function () return f(a, b, c, d);
  }
  
}

class Function5Opt2s 
{
  
  /**
   * Partially applies the function f with the first to third parameter and applying the default arguments.
   */
  public static function _123_ < A, B, C, D, E, F > (f:A->B->C->?D->?E->F, a:A, b:B, c:C):Void->F
  {
    return function () return f(a, b, c);
  }
}

class Function5Opt1s 
{
  
  /**
   * Partially applies the function f with the first to third parameter and applying the default arguments.
   */
  public static function _123_ < A, B, C, D, E, F > (f:A->B->C->D->?E->F, a:A, b:B, c:C):D->F
  {
    return function (d:D) return f(a, b, c, d);
  }
}

class Function5s 
{
  /**
   * Transform f into a function taking only one parameter and returning another function also only taking one paramter as the result.
   */
  public static function curry < A, B, C, D, E,Z > (f:A->B->C->D->E->Z):A->(B->(C->(D->(E->Z))))
  {
    return function (a:A) 
      return function (b:B) 
        return function(c:C) 
          return function(d:D) 
            return function(e:E) 
              return f(a, b, c, d, e);
  }

  /**
   * Converts a curried function into a function taking multiple arguments.
   */
  public static function uncurry <A,B,C,D,E, Z>(f:A->(B->(C->(D->(E->Z))))):A->B->C->D->E->Z
  {
    return function (a,b,c,d,e) return f(a)(b)(c)(d)(e);
  }
  /**
   * Reverses the first 2 arguments of f.
   */
  public static function flip < A, B, C, D, E, F > (f:A->B->C->D->E->F):B->A->C->D->E->F
  {
    return function (b, a, c, d, e) return f(a, b, c, d, e);
  }
  
  /**
   * Partially applies the function f with the first parameter.
   */
  public static function _1 < A, B, C, D, E, F > (f:A->B->C->D->E->F, a:A):B->C->D->E->F
  {
    return function (b:B, c:C, d:D, e:E) return f(a, b, c, d, e);
  }
  
  /**
   * Partially applies the function f with the second parameter.
   */
  public static function _2 < A, B, C, D, E, F > (f:A->B->C->D->E->F, b:B):A->C->D->E->F
  {
    return function (a:A, c:C, d:D, e:E) return f(a, b, c, d, e);
  }
  
  /**
   * Partially applies the function f with the third parameter.
   */
  public static function _3 < A, B, C, D, E, F > (f:A->B->C->D->E->F, c:C):A->B->D->E->F
  {
    return function (a:A, b:B, d:D, e:E) return f(a, b, c, d, e);
  }
  
  /**
   * Partially applies the function f with the fourth parameter.
   */
  public static function _4 < A, B, C, D, E, F > (f:A->B->C->D->E->F, d:D):A->B->C->E->F
  {
    return function (a:A, b:B, c:C, e:E) return f(a, b, c, d, e);
  }
  
  /**
   * Partially applies the function f with the fifth parameter.
   */
  public static function _5 < A, B, C, D, E, F > (f:A->B->C->D->E->F, e:E):A->B->C->D->F
  {
    return function (a:A, b:B, c:C, d:D) return f(a, b, c, d, e);
  }
  
  /**
   * Partially applies the function f with the first to forth parameters.
   */
  public static function _1234 < A, B, C, D, E, F > (f:A->B->C->D->E->F, a:A, b:B, c:C, d:D):E->F
  {
    return function (e:E) return f(a, b, c, d, e);
  }
  
  /**
   * Partially applies the function f with the first to third parameter.
   */
  public static function _123 < A, B, C, D, E, F > (f:A->B->C->D->E->F, a:A, b:B, c:C):D->E->F
  {
    return function (d:D, e:E) return f(a, b, c, d, e);
  }
  
  /**
   * Partially applies the function f with the first and second parameter.
   */
  public static function _12 < A, B, C, D, E, F > (f:A->B->C->D->E->F, a:A, b:B):C->D->E->F
  {
    return function (c:C, d:D, e:E) return f(a, b, c, d, e);
  }
  
  /**
   * Partially applies the function f with the second to fifth parameters.
   */
  public static function _2345 < A, B, C, D, E, F > (f:A->B->C->D->E->F, b:B, c:C, d:D, e:E):A->F
  {
    return function (a:A) return f(a, b, c, d, e);
  }
  
  /**
   * Partially applies the function f with all parameters and returns a thunk.
   */
  public static function _12345 < A, B, C, D, E, F > (f:A->B->C->D->E->F, a:A, b:B, c:C, d:D, e:E):Thunk<F>
  {
    return function () return f(a, b, c, d, e);
  }
}

class Function6s 
{
  /**
   * Transform f into a function taking only one parameter and returning another function also only taking one paramter as the result.
   */
  public static function curry < A, B, C, D, E, F, Z > (f:A->B->C->D->E->F->Z):A->(B->(C->(D->(E->(F->Z)))))
  {
    return function (a:A) 
      return function (b:B) 
        return function(c:C) 
          return function(d:D) 
            return function(e:E) 
              return function(f1:F) 
                return f(a, b, c, d, e, f1);
  }

  /**
   * Converts a curried function into a function taking multiple arguments.
   */
  public static function uncurry <A,B,C,D,E,F,Z>(f:A->(B->(C->(D->(E->(F->Z)))))):A->B->C->D->E->F->Z
  {
    return function (a,b,c,d,e,f1) return f(a)(b)(c)(d)(e)(f1);
  }
}