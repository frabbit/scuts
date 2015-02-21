package scuts.ht.instances.std;

import scuts.ht.classes.Empty;
import scuts.ht.classes.Monad;
import scuts.ds.ImLists;




class ImListEmpty implements Empty<ImList<_>>
{
  public function new () {}

  public inline function empty <A>():ImList<A>
  {
    return ImLists.mkEmpty();
  }

}
