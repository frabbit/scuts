package scuts.ht.instances.std;
import scuts.ht.classes.FoldableAbstract;
import scuts.ds.LazyLists;



class LazyListFoldable extends FoldableAbstract<LazyList<_>>
{
  public function new () {}

  override public inline function foldRight <A,B>(v:LazyList<A>, init:B, f:A->B->B ):B
  {
    return LazyLists.foldRight(v, init, f);
  }

  override public inline function foldLeft <A,B>(v:LazyList<B>, init:A, f:A->B->A ):A
  {
    return LazyLists.foldLeft(v, init, f);
  }

}



