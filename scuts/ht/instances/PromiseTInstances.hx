
package scuts.ht.instances;

import scuts.ht.classes.Monad;
import scuts.ht.classes.MonadEmpty;
import scuts.ht.classes.MonadEmptyAbstract;

using scuts.core.Promises;

using scuts.ht.instances.PromiseTInstances.PromiseT;

class PromiseTInstances {

  @:implicit @:noUsing
  public static function monadEmpty <M>(monadM:Monad<M>):MonadEmpty<PromiseT<M,In>> return new PromiseTMonadEmpty(monadM);

  @:implicit @:noUsing
  public static inline function monad <M>(monadM:Monad<M>):Monad<PromiseT<M,In>> return monadEmpty(monadM);

}


abstract PromiseT<M, A>(M<Promise<A>>)
{
  public function new (x:M<Promise<A>>) {
    this = x;
  }
  public function unwrap ():M<Promise<A>> {
    return this;
  }

  public static function runT <M1,A1>(a:PromiseT<M1,A1>):M1<Promise<A1>>
  {
    return a.unwrap();
  }
  public static function promiseT <M1,A1>(a:M1<Promise<A1>>):PromiseT<M1,A1>
  {
    return new PromiseT(a);
  }
}



class PromiseTMonadEmpty<M> extends MonadEmptyAbstract<PromiseT<M,In>>
{
  var base:Monad<M>;

  public function new (base:Monad<M>)
  {
    this.base = base;
  }

  override public function flatMap<A,B>(val:PromiseT<M,A>, f: A->PromiseT<M,B>):PromiseT<M, B>
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

  override public function pure<A>(x:A):PromiseT<M,A> {
    return base.pure(Promises.pure(x)).promiseT();
  }

  override public function map<A,B>(v:PromiseT<M, A>, f:A->B):PromiseT<M, B>
  {
    return base.map(v.runT(), Promises.map.bind(_,f)).promiseT();
  }

  override public inline function empty <A>():PromiseT<M,A>
  {
    return base.pure(Promises.cancelled("error")).promiseT();
  }
}

