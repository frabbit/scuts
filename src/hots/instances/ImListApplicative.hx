package hots.instances;

import hots.classes.ApplicativeAbstract;
import hots.In;
import hots.classes.Applicative;
import hots.of.ImListOf;
import scuts.core.extensions.ImLists;
import scuts.core.types.ImList;

using hots.ImplicitCasts;
using hots.Hots;

class ImListApplicative extends ApplicativeAbstract<ImList<In>>
{
  public function new (pure, func) super(pure, func)
  
  override public function apply<B,C>(f:ImListOf<B->C>, v:ImListOf<B>):ImListOf<C> 
  {
    return ImLists.flatMap(f, function (f1) 
    {
      return ImLists.map(v, function (x) return f1(x));
    });
  }
}
