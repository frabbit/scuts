package hots.instances;
import hots.classes.FoldableAbstract;
import hots.In;
import hots.Of;
import hots.of.LazyListOf;
import scuts.core.types.LazyList;
import scuts.core.extensions.LazyLists;


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



