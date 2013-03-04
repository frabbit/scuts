package scuts1.instances.std;

import scuts1.classes.Bind;
import scuts1.core.In;
import scuts1.core.Of;

import scuts1.instances.std.PromiseTOf;

import scuts.core.Promises;

import scuts1.classes.Monad;



class PromiseTBind<M> implements Bind<Of<M, Promise<In>>> {
  
  var base:Monad<M>;
  
  public function new (base:Monad<M>) {
    this.base = base;
  }
  
  public function flatMap<A,B>(val:PromiseTOf<M,A>, f: A->PromiseTOf<M,B>):PromiseTOf<M, B> 
  {
    function f1 (a:Promise<A>):Of<M,Promise<B>> 
    {
      var x:Promise<B> = new Promise();
      a.onCancelled(x.cancel);
      a.onComplete(function (a1:A) 
      {
        var z2:PromiseTOf<M,B> = f(a1);
        function x1 (z:Promise<B>):Promise<B> 
        {
          z.onComplete(x.complete);
          z.onCancelled(x.cancel);
          z.onProgress(function (p) x.progress(0.5 + 0.5 * p));
          return z;
        }
        
        base.map(z2, x1);
      });
      a.onProgress(function (p) x.progress(0.5 * p));
      
      return base.pure(x);
    }
    
    return base.flatMap(val, f1);
  }
}
