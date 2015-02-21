package scuts.ht.instances.std;

import scuts.ht.classes.Empty;
import scuts.core.Promises;




class PromiseEmpty implements Empty<Promise<_>>
{
  public function new () {}

  public inline function empty <A>():Promise<A>
  {
    return Promises.cancelled(scuts.core.Unit);
  }

}
