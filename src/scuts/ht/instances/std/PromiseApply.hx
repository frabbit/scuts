package scuts.ht.instances.std;

import scuts.ht.classes.Apply;
import scuts.ht.core.In;
import scuts.ht.instances.std.PromiseOf;
import scuts.core.Promises;



class PromiseApply implements Apply<Promise<In>>
{
  public function new () {}
  
  public function apply<A,B>(f:PromiseOf<A->B>, x:PromiseOf<A>):PromiseOf<B> 
  {
    return Promises.apply(f,x);
  }

}
