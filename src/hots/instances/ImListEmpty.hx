package hots.instances;

import hots.classes.Empty;
import hots.classes.Monad;
import hots.In;
import hots.of.ImListOf;
import scuts.core.extensions.ImLists;
import scuts.core.types.ImList;




class ImListEmpty implements Empty<ImList<In>>
{
  public function new () {}
  
  public inline function empty <A>():ImListOf<A> 
  {
    return ImLists.mkEmpty();
  }
  
}
