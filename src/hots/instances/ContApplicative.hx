package hots.instances;

#if false

import hots.classes.ApplicativeAbstract;
import hots.In;
import hots.classes.Applicative;
import hots.of.ArrayOf;
import hots.of.ContOf;
import hots.of.ContOf;
import scuts.core.types.Cont;

using hots.box.ArrayBox;

class ContApplicative<R> extends ApplicativeAbstract<Cont<In,R>>
{
  public function new (pure, func) super(pure, func)
  
  public function apply<B,C>(f:ContOf<B->C,R>, v:ContOf<B,R>):ContOf<C,R> 
  {
    
    return function (z:C->R):R {
      
      // ((B->C)->R)->R
      // (B->R)->R
      
      // C -> R
      
      function y (b:B) {
        f(b)
      }
      
      function x (c:C):R {
        
        
        
      }
      
      return z(x);
      
      
    }
    
  }
}

#end
