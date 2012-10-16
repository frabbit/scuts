package hots.instances;

import hots.classes.FoldableAbstract;
import hots.In;
import hots.Of;
import hots.of.ImListOf;
import scuts.core.ImLists;
import scuts.core.ImList;


class ImListFoldable extends FoldableAbstract<ImList<In>>
{
  public function new () {}
  
  override public inline function foldRight <A,B>(x:ImListOf<A>, init:B, f:A->B->B ):B  
  {
    return ImLists.foldRight(x, f, init);
  }
  
  override public inline function foldLeft <A,B>(x:ImListOf<B>, init:A, f:A->B->A ):A 
  {
    return ImLists.foldLeft(x, f, init);
  }
  
}



