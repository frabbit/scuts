package scuts1.instances.std;

import scuts1.classes.FoldableAbstract;
import scuts1.core.In;
import scuts1.core.Of;
import scuts1.instances.std.ImListOf;
import scuts.ds.ImLists;



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



