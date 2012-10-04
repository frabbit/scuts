package hots.instances;

import hots.classes.PureAbstract;
import hots.of.ImListOf;
import scuts.core.extensions.ImLists;
import scuts.core.types.ImList;
import hots.In;


class ImListPure extends PureAbstract<ImList<In>>
{
  public function new () {}
  
  override public function pure<B>(b:B):ImListOf<B> 
  {
    return ImLists.mkOne(b);
  }
}
