package hots.instances;

import hots.classes.Apply;
import hots.In;
import hots.of.ImListOf;
import scuts.core.ImLists;
import scuts.core.ImList;

using hots.ImplicitCasts;
using hots.Hots;

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
