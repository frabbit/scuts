package hots.instances;

import hots.classes.Bind;
import hots.In;
import hots.Of;

import hots.of.PromiseTOf;

import scuts.core.types.Promise;

import hots.classes.Monad;

using hots.ImplicitCasts;
using hots.Identity;

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
        
        base.map(z2.runT(), x1);
      });
      a.onProgress(function (p) x.progress(0.5 * p));
      
      return base.pure(x);
    }
    
    return base.flatMap(val.runT(), f1);
  }
}
