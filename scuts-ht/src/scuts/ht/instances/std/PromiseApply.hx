package scuts.ht.instances.std;

import scuts.ht.classes.Apply;
import scuts.ht.classes.ApplyAbstract;
import scuts.ht.core.In;
import scuts.ht.instances.std.PromiseOf;
import scuts.core.Promises;



class PromiseApply extends ApplyAbstract<PromiseD<In>>
{
  public function new (func) super(func);
  
  override public function apply<A,B>(x:PromiseOf<A>, f:PromiseOf<A->B>):PromiseOf<B> 
  {
    return Promises.apply(f,x);
  }

}
