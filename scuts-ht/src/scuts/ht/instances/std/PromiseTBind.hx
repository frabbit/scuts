package scuts.ht.instances.std;

import scuts.ht.classes.Bind;

using scuts.ht.instances.std.PromiseT;

using scuts.core.Promises;

import scuts.ht.classes.Monad;



class PromiseTBind<M> implements Bind<PromiseT<M, In>> {

  var base:Monad<M>;

  public function new (base:Monad<M>) {
    this.base = base;
  }

  public function flatMap<A,B>(val:PromiseT<M,A>, f: A->PromiseT<M,B>):PromiseT<M, B>
  {
    function f1 (a:Promise<A>):Of<M,Promise<B>>
    {
      var x:Deferred<B> = Promises.deferred();
      a.onFailure(x.failure);
      a.onSuccess(function (a1:A)
      {
        var z2:PromiseT<M,B> = f(a1);
        function x1 (z:Promise<B>):Promise<B>
        {
          z.onSuccess(x.success);
          z.onFailure(x.failure);
          z.onProgress(function (p) x.progress(0.5 + 0.5 * p));
          return z;
        }

        base.map(z2.runT(), x1);
      });
      a.onProgress(function (p) x.progress(0.5 * p));

      return base.pure(x.asPromiseD());
    }

    return base.flatMap(val.runT(), f1).promiseT();
  }
}
