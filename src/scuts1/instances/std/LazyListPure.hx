package scuts1.instances.std;

import scuts1.classes.Pure;
import scuts1.instances.std.LazyListOf;
import scuts.ds.LazyLists;
import scuts1.core.In;

class LazyListPure implements Pure<LazyList<In>>
{
  public function new () {}
  
  public function pure<B>(b:B):LazyListOf<B> 
  {
    return LazyLists.mkOne(b);
  }
}
