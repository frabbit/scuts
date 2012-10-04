package hots.instances;

import hots.classes.FunctorAbstract;
import hots.In;
import hots.of.LazyListOf;
import hots.classes.Functor;
import scuts.core.extensions.LazyLists;
import scuts.core.types.LazyList;



class LazyListFunctor extends FunctorAbstract<LazyList<In>>
{
  public function new () {}
  
  override public function map<B,C>(of:LazyListOf<B>, f:B->C):LazyListOf<C> {
    return LazyLists.map(of, f);
  }
}