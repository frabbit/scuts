package scuts.ht.instances.std;

import scuts.ht.classes.FoldableAbstract;
import scuts.ht.core.In;
import scuts.ht.core.Of;
import scuts.ht.instances.std.ImListOf;
import scuts.ds.ImLists;



class ImListFoldable extends FoldableAbstract<ImList<In>>
{
  public function new () {}
  
  override public inline function foldRight <A,B>(x:ImListOf<A>, init:B, f:A->B->B ):B  
  {
    return ImLists.foldRight(x, init, f);
  }
  
  override public inline function foldLeft <A,B>(x:ImListOf<B>, init:A, f:A->B->A ):A 
  {
    return ImLists.foldLeft(x, init, f);
  }
  
}



