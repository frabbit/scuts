package scuts1.instances.std;

import scuts1.classes.Apply;
import scuts1.core.In;
import scuts1.instances.std.PromiseOf;
import scuts.core.Promises;



class PromiseApply implements Apply<Promise<In>>
{
  public function new () {}
  
  public function apply<A,B>(f:PromiseOf<A->B>, x:PromiseOf<A>):PromiseOf<B> 
  {
    return Promises.apply(f,x);
  }

}
