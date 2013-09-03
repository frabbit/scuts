package scuts.ht.instances.std;

import scuts.ht.classes.Bind;
import scuts.ht.core.In;
import scuts.ht.instances.std.LazyListOf;
import scuts.ds.LazyLists;


class LazyListBind implements Bind<LazyList<In>>
{
  public function new () {}
  
  public function flatMap<A,B>(v:LazyListOf<A>, f: A->LazyListOf<B>):LazyListOf<B> 
  {
    return LazyLists.flatMap(v, f);
  }
}
