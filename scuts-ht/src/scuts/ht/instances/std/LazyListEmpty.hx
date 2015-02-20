package scuts.ht.instances.std;

import scuts.ht.classes.Empty;
import scuts.ht.classes.Monad;
import scuts.ds.LazyLists;



class LazyListEmpty implements Empty<LazyList<In>>
{
  public function new () {}

  public inline function empty <A>():LazyList<A>
  {
    return LazyLists.mkEmpty();
  }
}
