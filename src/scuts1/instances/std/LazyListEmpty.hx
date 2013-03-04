package scuts1.instances.std;

import scuts1.classes.Empty;
import scuts1.classes.Monad;
import scuts1.core.In;
import scuts1.instances.std.LazyListOf;
import scuts.ds.LazyLists;



class LazyListEmpty implements Empty<LazyList<In>>
{
  public function new () {}
  
  public inline function empty <A>():LazyListOf<A> 
  {
    return LazyLists.mkEmpty();
  }
}
