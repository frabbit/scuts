package hots.instances;

import hots.classes.ApplicativeAbstract;
import hots.In;
import hots.of.LazyListOf;

import scuts.core.types.LazyList;
import scuts.core.extensions.LazyLists;



class LazyListApplicative extends ApplicativeAbstract<LazyList<In>>
{
  public function new (pure, functor) super(pure, functor)
  
  override public function apply<B,C>(f:LazyListOf<B->C>, v:LazyListOf<B>):LazyListOf<C> 
  {
    return LazyLists.flatMap(f, function (f1) 
    {
      return LazyLists.map(v, function (x) return f1(x));
    });
  }
}
