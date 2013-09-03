package scuts.ht.instances.std;

import scuts.ht.classes.Empty;
import scuts.ht.core.In;
import scuts.ht.instances.std.PromiseOf;
import scuts.core.Promises;




class PromiseEmpty implements Empty<PromiseD<In>>
{
  public function new () {}
  
  public inline function empty <A>():PromiseOf<A> 
  {
    return Promises.cancelled(scuts.core.Unit);
  }
  
}
