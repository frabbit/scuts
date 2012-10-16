package hots.instances;

import hots.classes.Pure;
import hots.In;
import hots.Of;
import hots.of.PromiseOf;
import scuts.core.Promises;
import scuts.core.Promise;

using hots.box.PromiseBox;

class PromisePure implements Pure<Promise<In>>
{
  public function new () {}
  
  public function pure<A>(a:A):PromiseOf<A> 
  {
    return Promises.pure(a);
  }
}
