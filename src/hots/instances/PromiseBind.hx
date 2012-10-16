package hots.instances;

import hots.classes.Bind;
import hots.In;
import hots.of.PromiseOf;
import scuts.core.Promises;
import scuts.core.Promise;


class PromiseBind implements Bind<Promise<In>>
{
  public function new () {}
  
  public function flatMap<A,B>(val:PromiseOf<A>, f: A->PromiseOf<B>):PromiseOf<B> 
  {
    return Promises.flatMap(val, f);
  }
}