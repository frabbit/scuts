package scuts1.instances.std;

import scuts1.classes.Empty;
import scuts1.core.In;
import scuts1.instances.std.PromiseOf;
import scuts.core.Promises;




class PromiseEmpty implements Empty<Promise<In>>
{
  public function new () {}
  
  public inline function empty <A>():PromiseOf<A> 
  {
    return Promises.cancelled();
  }
  
}
