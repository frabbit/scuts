package hots.instances;

import hots.classes.Pure;
import hots.of.ImListOf;
import scuts.core.extensions.ImLists;
import scuts.core.types.ImList;
import hots.In;


class ImListPure implements Pure<ImList<In>>
{
  public function new () {}
  
  public function pure<B>(b:B):ImListOf<B> 
  {
    return ImLists.mkOne(b);
  }
}
