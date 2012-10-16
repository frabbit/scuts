package hots.instances;

import hots.classes.Empty;
import hots.In;
import hots.of.PromiseOf;
import scuts.core.Promises;


import scuts.core.Promise;


class PromiseEmpty implements Empty<Promise<In>>
{
  public function new () {}
  
  public inline function empty <A>():PromiseOf<A> 
  {
    return Promises.cancelled();
  }
  
}
