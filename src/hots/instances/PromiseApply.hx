package hots.instances;

import hots.classes.Apply;
import hots.In;
import hots.of.PromiseOf;
import scuts.core.extensions.Promises;
import scuts.core.types.Promise;


class PromiseApply implements Apply<Promise<In>>
{
  public function new () {}
  
  public function apply<A,B>(f:PromiseOf<A->B>, x:PromiseOf<A>):PromiseOf<B> 
  {
    return Promises.apply(f,x);
  }

}
