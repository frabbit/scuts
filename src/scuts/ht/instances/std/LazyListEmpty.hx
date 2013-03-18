package scuts.ht.instances.std;

import scuts.ht.classes.Empty;
import scuts.ht.classes.Monad;
import scuts.ht.core.In;
import scuts.ht.instances.std.LazyListOf;
import scuts.ds.LazyLists;



class LazyListEmpty implements Empty<LazyList<In>>
{
  public function new () {}
  
  public inline function empty <A>():LazyListOf<A> 
  {
    return LazyLists.mkEmpty();
  }
}
