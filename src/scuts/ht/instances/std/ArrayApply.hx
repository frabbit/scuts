package scuts.ht.instances.std;

import scuts.ht.classes.Apply;
import scuts.ht.classes.ApplyAbstract;
import scuts.ht.core.In;
import scuts.ht.classes.Applicative;
import scuts.ht.instances.std.ArrayOf;

using scuts.ht.syntax.Arrays;

class ArrayApply extends ApplyAbstract<Array<In>>
{
  public function new (func) {
  	super(func);
  }
  
  override public function apply<B,C>(v:ArrayOf<B>, f:ArrayOf<B->C>):ArrayOf<C> 
  {
    var res = [];
    
    for (f1 in f.unbox()) for (v1 in v.unbox()) res.push(f1(v1));
    return res;
  }
}
