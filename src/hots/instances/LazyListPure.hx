package hots.instances;

import hots.classes.Pure;
import hots.of.LazyListOf;
import scuts.core.extensions.LazyLists;
import scuts.core.types.LazyList;
import hots.In;

class LazyListPure implements Pure<LazyList<In>>
{
  public function new () {}
  
  public function pure<B>(b:B):LazyListOf<B> 
  {
    return LazyLists.mkOne(b);
  }
}
