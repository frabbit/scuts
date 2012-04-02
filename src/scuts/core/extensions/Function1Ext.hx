package scuts.core.extensions;


// TODO: A Macro would be nice, something like F.compose( a, b, c ) with optimizations, auto-currying and short lambdas.
// Maybe something like a functional context: F.ctx (' a( b . c . f.flip() . x => x + 1 * _+2 ')(d)
class Function1Ext 
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