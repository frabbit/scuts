package hots.instances;

import hots.classes.Pure;
import hots.In;
import hots.Of;
import hots.of.PromiseOf;
import scuts.core.extensions.Promises;
import scuts.core.types.Promise;

using hots.box.PromiseBox;

class PromisePure implements Pure<Promise<In>>
{
  public function new () {}
  
  public function pure<A>(a:A):PromiseOf<A> 
  {
    return Promises.pure(a);
  }
}
