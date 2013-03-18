package scuts.ht.instances.std;

import scuts.ht.classes.Pure;
import scuts.ht.instances.std.ImListOf;
import scuts.ds.ImLists;
import scuts.ht.core.In;


class ImListPure implements Pure<ImList<In>>
{
  public function new () {}
  
  public function pure<B>(b:B):ImListOf<B> 
  {
    return ImLists.mkOne(b);
  }
}
