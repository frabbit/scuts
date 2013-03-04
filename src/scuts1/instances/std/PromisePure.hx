package scuts1.instances.std;

import scuts1.classes.Pure;
import scuts1.core.In;
import scuts1.core.Of;
import scuts1.instances.std.PromiseOf;
import scuts.core.Promises;



class PromisePure implements Pure<Promise<In>>
{
  public function new () {}
  
  public function pure<A>(a:A):PromiseOf<A> 
  {
    return Promises.pure(a);
  }
}
