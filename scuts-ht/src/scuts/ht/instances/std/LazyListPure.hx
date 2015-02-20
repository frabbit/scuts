package scuts.ht.instances.std;

import scuts.ht.classes.Pure;
import scuts.ds.LazyLists;

class LazyListPure implements Pure<LazyList<In>>
{
  public function new () {}

  public function pure<B>(b:B):LazyList<B>
  {
    return LazyLists.mkOne(b);
  }
}
