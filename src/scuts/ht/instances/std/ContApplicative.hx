package scuts.ht.instances.std;

#if false

import scuts.ht.classes.ApplicativeAbstract;
import scuts.ht.core.In;
import scuts.ht.classes.Applicative;
import scuts.ht.instances.std.ArrayOf;
import scuts.ht.instances.std.ContOf;
import scuts.ht.instances.std.ContOf;
import scuts.core.Cont;

using scuts.ht.box.ArrayBox;

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
