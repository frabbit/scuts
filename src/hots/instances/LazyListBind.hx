package hots.instances;

import hots.classes.Bind;
import hots.In;
import hots.of.LazyListOf;
import scuts.core.extensions.LazyLists;
import scuts.core.types.LazyList;


class LazyListBind implements Bind<LazyList<In>>
{
  public function new () {}
  
  public function flatMap<A,B>(v:LazyListOf<A>, f: A->LazyListOf<B>):LazyListOf<B> 
  {
    return LazyLists.flatMap(v, f);
  }
}
