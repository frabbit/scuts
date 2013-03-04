package scuts1.instances.std;

import scuts1.classes.Bind;
import scuts1.core.In;
import scuts1.instances.std.LazyListOf;
import scuts.ds.LazyLists;


class LazyListBind implements Bind<LazyList<In>>
{
  public function new () {}
  
  public function flatMap<A,B>(v:LazyListOf<A>, f: A->LazyListOf<B>):LazyListOf<B> 
  {
    return LazyLists.flatMap(v, f);
  }
}
