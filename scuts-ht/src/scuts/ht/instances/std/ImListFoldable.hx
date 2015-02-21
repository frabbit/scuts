package scuts.ht.instances.std;

import scuts.ht.classes.FoldableAbstract;
import scuts.ds.ImLists;



class ImListFoldable extends FoldableAbstract<ImList<_>>
{
  public function new () {}

  override public inline function foldRight <A,B>(x:ImList<A>, init:B, f:A->B->B ):B
  {
    return ImLists.foldRight(x, init, f);
  }

  override public inline function foldLeft <A,B>(x:ImList<B>, init:A, f:A->B->A ):A
  {
    return ImLists.foldLeft(x, init, f);
  }

}



