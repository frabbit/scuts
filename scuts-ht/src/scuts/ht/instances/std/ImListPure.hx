package scuts.ht.instances.std;

import scuts.ht.classes.Pure;
import scuts.ds.ImLists;


class ImListPure implements Pure<ImList<In>>
{
  public function new () {}

  public function pure<B>(b:B):ImList<B>
  {
    return ImLists.mkOne(b);
  }
}
