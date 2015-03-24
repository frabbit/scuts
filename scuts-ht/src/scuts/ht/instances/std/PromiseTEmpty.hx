package scuts.ht.instances.std;

import scuts.ht.classes.Empty;
import scuts.core.Promises;



import scuts.ht.classes.Monad;



class PromiseTEmpty<M> implements Empty<M<PromiseD<_>>>
{
  var monadM:Monad<M>;

  public function new (monadM:Monad<M>) {
    this.monadM = monadM;
  }

  public inline function empty <A>():PromiseT<M,A>
  {
  	inline function asPromiseD <T,A>(p:Promise<T,A>):PromiseD<A> return p;

    return monadM.pure(asPromiseD(Promises.cancelled("error")));
  }
}

