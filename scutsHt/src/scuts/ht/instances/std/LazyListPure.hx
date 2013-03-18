package scuts.ht.instances.std;

import scuts.ht.classes.Pure;
import scuts.ht.instances.std.LazyListOf;
import scuts.ds.LazyLists;
import scuts.ht.core.In;

class LazyListPure implements Pure<LazyList<In>>
{
  public function new () {}
  
  public function pure<B>(b:B):LazyListOf<B> 
  {
    return LazyLists.mkOne(b);
  }
}
