package scuts1.instances.std;

import scuts1.classes.Pure;
import scuts1.instances.std.ImListOf;
import scuts.ds.ImLists;
import scuts1.core.In;


class ImListPure implements Pure<ImList<In>>
{
  public function new () {}
  
  public function pure<B>(b:B):ImListOf<B> 
  {
    return ImLists.mkOne(b);
  }
}
