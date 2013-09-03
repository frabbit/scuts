package scuts.ht.instances.std;

import scuts.ht.classes.Bind;
import scuts.ht.core.In;
import scuts.ht.core.Of;

import scuts.ht.instances.std.PromiseTOf;

using scuts.core.Promises;

import scuts.ht.classes.Monad;



class PromiseTBind<M> implements Bind<Of<M, PromiseD<In>>> {
  
  var base:Monad<M>;
  
  public function new (base:Monad<M>) {
    this.base = base;
  }
  
  public function flatMap<A,B>(val:PromiseTOf<M,A>, f: A->PromiseTOf<M,B>):PromiseTOf<M, B> 
  {
    function f1 (a:PromiseD<A>):Of<M,PromiseD<B>> 
    {
      var x:Deferred<Dynamic,B> = Promises.deferred();
      a.onFailure(x.failure);
      a.onSuccess(function (a1:A) 
      {
        var z2:PromiseTOf<M,B> = f(a1);
        function x1 (z:PromiseD<B>):PromiseD<B> 
        {
          z.onSuccess(x.success);
          z.onFailure(x.failure);
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
