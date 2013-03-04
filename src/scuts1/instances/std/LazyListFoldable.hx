package scuts1.instances.std;
import scuts1.classes.FoldableAbstract;
import scuts1.core.In;
import scuts1.core.Of;
import scuts1.instances.std.LazyListOf;
import scuts.ds.LazyList;
import scuts.ds.LazyLists;


class LazyListFoldable extends FoldableAbstract<LazyList<In>>
{
  public function new () {}
  
  override public inline function foldRight <A,B>(v:LazyListOf<A>, init:B, f:A->B->B ):B  
  {
    return LazyLists.foldRight(v, init, f);
  }
  
  override public inline function foldLeft <A,B>(v:LazyListOf<B>, init:A, f:A->B->A ):A 
  {
    return LazyLists.foldLeft(v, init, f);
  }
  
}



