package scuts.ht.instances.std;

import scuts.ht.classes.Apply;
import scuts.ht.classes.ApplyAbstract;
import scuts.ht.core.In;
import scuts.ht.instances.std.ImListOf;
import scuts.ds.ImLists;


using scuts.ht.core.Hots;

class ImListApply extends ApplyAbstract<ImList<In>>
{
  public function new (func) {
  	super(func);
  }
  
  override public function apply<B,C>( v:ImListOf<B>, f:ImListOf<B->C>):ImListOf<C> 
  {
    return ImLists.flatMap(f, function (f1) 
    {
      return ImLists.map(v, function (x) return f1(x));
    });
  }
}
