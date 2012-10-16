package hots.instances;

import hots.classes.Empty;
import hots.classes.Monad;
import hots.In;
import hots.of.LazyListOf;
import scuts.core.LazyLists;
import scuts.core.LazyList;

using hots.box.LazyListBox;

class LazyListEmpty implements Empty<LazyList<In>>
{
  public function new () {}
  
  public inline function empty <A>():LazyListOf<A> 
  {
    return LazyLists.mkEmpty();
  }
}
