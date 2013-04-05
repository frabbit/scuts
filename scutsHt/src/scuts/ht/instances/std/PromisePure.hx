package scuts.ht.instances.std;

import scuts.ht.classes.Pure;
import scuts.ht.core.In;
import scuts.ht.core.Of;
import scuts.ht.instances.std.PromiseOf;
import scuts.core.Promises;



class PromisePure implements Pure<PromiseD<In>>
{
  public function new () {}
  
  public function pure<A>(a:A):PromiseOf<A> 
  {
    return Promises.pure(a);
  }
}
