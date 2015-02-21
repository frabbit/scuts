package scuts.ht.instances.std;

import scuts.ht.classes.Functor;
import scuts.core.Promises;


class PromiseFunctor implements Functor<PromiseD<_>>
{
  public function new () {}

  public function map<A,B>(of:Promise<A>, f:A->B):Promise<B>
  {
    return Promises.map(of, f);
  }
}
