package scuts.ht.instances.std;

import scuts.ht.classes.Bind;
import scuts.core.Promises;



class PromiseBind implements Bind<Promise<_>>
{
  public function new () {}

  public function flatMap<A,B>(val:Promise<A>, f: A->Promise<B>):Promise<B>
  {
    return Promises.flatMap(val, f);
  }
}