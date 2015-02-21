package scuts.ht.instances.std;

import scuts.ht.classes.Apply;
import scuts.ht.classes.ApplyAbstract;
import scuts.core.Promises;



class PromiseApply extends ApplyAbstract<Promise<_>>
{
  public function new (func) super(func);

  override public function apply<A,B>(x:Promise<A>, f:Promise<A->B>):Promise<B>
  {
    return Promises.apply(f,x);
  }

}
