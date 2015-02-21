package scuts.ht.instances.std;

import scuts.ht.classes.Pure;
import scuts.core.Promises;



class PromisePure implements Pure<Promise<_>>
{
  public function new () {}

  public function pure<A>(a:A):Promise<A>
  {
    return Promises.pure(a);
  }
}
