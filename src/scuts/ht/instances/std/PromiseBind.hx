package scuts.ht.instances.std;

import scuts.ht.classes.Bind;
import scuts.ht.core.In;
import scuts.ht.instances.std.PromiseOf;
import scuts.core.Promises;



class PromiseBind implements Bind<Promise<In>>
{
  public function new () {}
  
  public function flatMap<A,B>(val:PromiseOf<A>, f: A->PromiseOf<B>):PromiseOf<B> 
  {
    return Promises.flatMap(val, f);
  }
}