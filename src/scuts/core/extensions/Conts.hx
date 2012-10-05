package scuts.core.extensions;
import scuts.core.types.Cont;

using scuts.core.extensions.Functions;


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
  /*
  public static function apply<R,B,C>(f:Cont<B->C,R>, v:Cont<B,R>):Cont<C,R> 
  {
    
    
    
    return function (z:C->R):R {
      
      // ((B->C)->R)->R
      // (B->R)->R
      
      // C -> R
      
      
      
      function (d:B->C):R {
        
      }
      
      function x (c:C):R {
        
        function y (b:B):R {
          
          
          
        }
        
        
      }
      
      return z(x);
      
      
    }
    
  }
  */
  
}