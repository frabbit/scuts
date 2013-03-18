package scuts.ht.instances.std;

import scuts.ht.classes.Empty;
import scuts.ht.classes.Monad;
import scuts.ht.core.In;
import scuts.ht.instances.std.ImListOf;
import scuts.ds.ImLists;




class ImListEmpty implements Empty<ImList<In>>
{
  public function new () {}
  
  public inline function empty <A>():ImListOf<A> 
  {
    return ImLists.mkEmpty();
  }
  
}
