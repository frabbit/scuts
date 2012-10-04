package hots.instances;

import hots.classes.PureAbstract;
import hots.of.LazyListOf;
import scuts.core.extensions.LazyLists;
import scuts.core.types.LazyList;
import hots.In;

class LazyListPure extends PureAbstract<LazyList<In>>
{
  public function new () {}
  
  override public function pure<B>(b:B):LazyListOf<B> 
  {
    return LazyLists.mkOne(b);
  }
}
