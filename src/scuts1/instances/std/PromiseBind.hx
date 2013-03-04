package scuts1.instances.std;

import scuts1.classes.Bind;
import scuts1.core.In;
import scuts1.instances.std.PromiseOf;
import scuts.core.Promises;



class PromiseBind implements Bind<Promise<In>>
{
  public function new () {}
  
  public function flatMap<A,B>(val:PromiseOf<A>, f: A->PromiseOf<B>):PromiseOf<B> 
  {
    return Promises.flatMap(val, f);
  }
}