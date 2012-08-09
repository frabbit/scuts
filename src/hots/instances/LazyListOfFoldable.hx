package hots.instances;
import hots.classes.FoldableAbstract;
import hots.In;
import hots.Of;
import scuts.data.LazyList;
import scuts.data.LazyLists;

using hots.box.LazyListBox;

class LazyListOfFoldable extends FoldableAbstract<LazyList<In>>
{
  public function new () {}
  
  override public inline function foldRight <A,B>(value:LazyListOf<A>, b:B, f:A->B->B ):B  
  {
    return LazyLists.foldRight(value.unbox(), f, b);
  }
  
  override public inline function foldLeft <A,B>(value:LazyListOf<B>, b:A, f:A->B->A ):A 
  {
    return LazyLists.foldLeft(value.unbox(), f, b);
  }
  
}



