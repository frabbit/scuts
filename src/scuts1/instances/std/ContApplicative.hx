package scuts1.instances.std;

#if false

import scuts1.classes.ApplicativeAbstract;
import scuts1.core.In;
import scuts1.classes.Applicative;
import scuts1.instances.std.ArrayOf;
import scuts1.instances.std.ContOf;
import scuts1.instances.std.ContOf;
import scuts.core.Cont;

using scuts1.box.ArrayBox;

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
