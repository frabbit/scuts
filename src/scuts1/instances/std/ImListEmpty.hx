package scuts1.instances.std;

import scuts1.classes.Empty;
import scuts1.classes.Monad;
import scuts1.core.In;
import scuts1.instances.std.ImListOf;
import scuts.ds.ImLists;




class ImListEmpty implements Empty<ImList<In>>
{
  public function new () {}
  
  public inline function empty <A>():ImListOf<A> 
  {
    return ImLists.mkEmpty();
  }
  
}
