package scuts.ht.instances.std;

import scuts.ht.classes.Bind;
import scuts.ds.LazyLists;


class LazyListBind implements Bind<LazyList<_>>
{
  public function new () {}

  public function flatMap<A,B>(v:LazyList<A>, f: A->LazyList<B>):LazyList<B>
  {
    return LazyLists.flatMap(v, f);
  }
}
