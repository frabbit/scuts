package scuts.core;


import haxe.PosInfos;

using scuts.core.Eithers;
import scuts.core.Thunk;
import scuts.core.Tuples;
import scuts.core.Unit;
import scuts.core.Tuples.*;
using scuts.core.Options;

class Functions {
  @:noUsing public static function identity <X> (x:X):X
  {
    return x;
  }

  @:noUsing public static function unit ():Unit return Unit;

}



class Function0s 
{
  

  /**
   * Creates a Memoized (Lazy) Version of f where only the first call is evaluated and every further
   * access returns the cached value.
   */
  public static function memoize <A,B>(f:Thunk<A>):Thunk<A>
  {
    var o = None;

    return function () return switch (o) 
    {
      case None: var r = f(); o = Some(r); r;
      case Some(x): x;
    }
  }

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
  public static function withoutOptionals <A,B>(f:?A->B):Option<A>->B
  {
    return function (a) return switch (a) 
    {
      case Some(x): f(x);
      case None: f();
    }
  }
  
}


class Function1s 
{


  public static function on <A,B,C>(on:B->B->C, f:A->B):A->A->C
  {
    return function (a,b) {
      return on(f(a), f(b));
    }
  }

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
  
  
}

class Function2OptsPosInfos 
{
  public static function compose < A, B, C,D > (f1:B->?PosInfos->D, f2:A->B):A->D
  {
    return function (a:A) return f1(f2(a));
  }
 
  
}

class Function2Opts 
{
  public static function compose < A, B, C,D > (f1:B->?C->D, f2:A->B):A->D
  {
    return function (a:A) return f1(f2(a));
  }
  
  public static function withoutOptionals <A,B,Z>(f:A->?B->Z):A->Option<B>->Z
  {
    return function (a,b) return switch (b) 
    {
      case Some(x): f(a,x);
      case None: f(a);
    }
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
    return function (a,b) return f(tup2(a,b));
  }
  
  /**
   * Converts f into a effectful function with no return type.
   */
  public static function toEffect <A,B,R>(f:A->B->R):A->B->Void
  {
    return function (a,b) f(a,b);
  }
}





class Function3Opts2
{
 
  
  public static function compose < A, B, C,D,X > (f1:A->?B->?C->D, f2:X->A):X->D
  {
    return function (a:X) return f1(f2(a));
  }

  public static function withoutOptionals <A,B,C,Z>(f:A->?B->?C->Z):A->Option<B>->Option<C>->Z
  {
    return function (a,b,c) return switch [b,c]
    {
      case [Some(b1), None]: f(a,b1);
      case [None, Some(c1)]: f(a,c1);
      case [Some(b1), Some(c1)]: f(a,b1,c1);
      case [None, None]: f(a);
    }
  }
}


class Function3Opts1
{
  public static function withoutOptionals <A,B,C,Z>(f:A->B->?C->Z):A->B->Option<C>->Z
  {
    return function (a,b,c) return switch c
    {
      case Some(c1): f(a,b,c1);
      case None: f(a,b);
      
    }
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
    return function (a,b,c) return f(tup3(a,b,c));
  }
  
  /**
   * Converts f into a effectful function with no return type.
   */
  public static function toEffect <A,B,C,R>(f:A->B->C->R):A->B->C->Void
  {
    return function (a,b,c) f(a,b,c);
  }
  
 
  

}

class Function4Opt1s {
  public static function withoutOptionals <A,B,C,D,Z>(f:A->B->C->?D->Z):A->B->C->Option<D>->Z
  {
    return function (a,b,c,d) return switch d
    {
      case Some(d1): f(a,b,c,d1);
      case None: f(a,b,c);
      
    }
  }
  
}

class Function4Opt3s {
   public static function withoutOptionals <A,B,C,D,Z>(f:A->?B->?C->?D->Z):A->Option<B>->Option<C>->Option<D>->Z
  {
    return function (a,b,c,d) return switch [b,c,d]
    {
      case [Some(b1), None     , None     ]: f(a,b1);
      case [None,     Some(c1) , None     ]: f(a,c1);
      case [None,     None     , Some(d1) ]: f(a,d1);
      
      case [Some(b1), Some(c1) , None     ]: f(a,b1,c1);
      case [Some(b1), None     , Some(d1) ]: f(a,b1,d1);
      case [None    , Some(c1) , Some(d1) ]: f(a,c1,d1);
      
      case [Some(b1), Some(c1) , Some(d1) ]: f(a,b1,c1,d1);

      case [None,     None     , None     ]: f(a);


    }
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
   * Converts f into a function taking a Tuple as only parameter instead of 4 values.
   */
  public static function tupled <A,B,C,D,Z>(f:A->B->C->D->Z):Tup4<A,B,C,D>->Z
  {
    return function (t) return f(t._1, t._2, t._3, t._4);
  }
  
  /**
   * Converts f into a function taking 4 parameters instead of a Tuple.
   */
  public static function untupled <A,B,C,D,Z>(f:Tup4<A,B,C,D>->Z):A->B->C->D->Z
  {
    return function (a,b,c,d) return f(tup4(a,b,c,d));
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
   * Converts f into a function taking a Tuple as only parameter instead of 5 values.
   */
  public static function tupled <A,B,C,D,E,Z>(f:A->B->C->D->E->Z):Tup5<A,B,C,D,E>->Z
  {
    return function (t) return f(t._1, t._2, t._3, t._4, t._5);
  }
  
  /**
   * Converts f into a function taking 5 parameters instead of a Tuple.
   */
  public static function untupled <A,B,C,D,E,Z>(f:Tup5<A,B,C,D,E>->Z):A->B->C->D->E->Z
  {
    return function (a,b,c,d,e) return f(tup5(a,b,c,d,e));
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