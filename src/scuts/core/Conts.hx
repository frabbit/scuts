package scuts.core;
import scuts.core.Cont;

using scuts.core.Functions;


class Conts 
{
  public static function map<R,B,C>(x:Cont<B,R>, f:B->C):Cont<C,R> 
  {
    return function (z : C->R):R return x( z.compose(f));
  }
  
  public static function flatMap<R,B,C>(x:Cont<B,R>, f:B->Cont<C,R>):Cont<C,R> 
  {
    return function (z : C->R):R {
      
      return x( function (b) return f(b)(z) );
    }
  }
  
  
  
  public static function pure<R,X>(x:X):Cont<X,R> 
  {
    return function (z : X->R):R {
      return z(x);
    }
  }
  
  public static function apply<R,A,B>(f:Cont<A->B,R>, v:Cont<A,R>):Cont<B,R> 
  {
    function z (g:A->B) return map(v, function (x) return g(x));
    return flatMap( f, z);
  }
  
  
}