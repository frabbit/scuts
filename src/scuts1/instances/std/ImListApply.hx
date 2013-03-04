package scuts1.instances.std;

import scuts1.classes.Apply;
import scuts1.core.In;
import scuts1.instances.std.ImListOf;
import scuts.ds.ImLists;


using scuts1.core.Hots;

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
