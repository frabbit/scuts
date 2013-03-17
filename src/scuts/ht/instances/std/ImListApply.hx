package scuts.ht.instances.std;

import scuts.ht.classes.Apply;
import scuts.ht.core.In;
import scuts.ht.instances.std.ImListOf;
import scuts.ds.ImLists;


using scuts.ht.core.Hots;

class ImListApply implements Apply<ImList<In>>
{
  public function new () {}
  
  public function apply<B,C>(f:ImListOf<B->C>, v:ImListOf<B>):ImListOf<C> 
  {
    return ImLists.flatMap(f, function (f1) 
    {
      return ImLists.map(v, function (x) return f1(x));
    });
  }
}
