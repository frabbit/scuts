package scuts1.instances.std;
import scuts1.classes.CategoryAbstract;
import scuts1.instances.std.ContOfOf;
import scuts.core.Conts;
import scuts.core.Cont;

import scuts1.core.In;


/**
 * ...
 * @author 
 */

class ContCategory<R> extends CategoryAbstract<In -> Cont<In, R>>
{

  public function new() {}
  
  override public function id <A>(a:A):ContOfOf<R, A, A> 
  {
    return function (a) return function (x:A->R):R return x(a);
  }
  /**
   * aka (.)
   */
  override public function dot <A,B,C>(f:ContOfOf<R, B, C>, g:ContOfOf<R, A, B>):ContOfOf<R, A, C> 
  {
    return _dot(f, g);
  }
  
  private static function _dot <R, A,B,C>(f:B->Cont<C, R>, g:A->Cont<B, R>):A->Cont<C, R> 
  {
    return function (a:A):Cont<C,R> {
        
      var v1:Cont<B,R> = g(a);
      var z:Cont<C,R>;
      
      v1(function (b:B):R {
        z = f(b);
        return null;
      });
      
      return z;
    }; 
  }
  
  
  
}