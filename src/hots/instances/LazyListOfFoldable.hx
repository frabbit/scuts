package hots.instances;
import hots.classes.FoldableAbstract;
import hots.In;
import hots.Of;

using hots.box.LazyListBox;

class LazyListOfFoldableImpl extends FoldableAbstract<LazyList<In>>
{
  public function new () {}
  
  override public inline function foldRight <A,B>(f:A->B->B, b:B, value:LazyListOf<A>):B  
  {
    return LazyLists.foldRight(value.unbox(), f, b);
  }
  
  override public inline function foldLeft <A,B>(f:A->B->A, b:A, value:LazyListOf<B>):A {
    trace("hui");
    return LazyLists.foldLeft(value.unbox(), f, b);
  }
  
}

typedef LazyListOfFoldable = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(LazyListOfFoldableImpl)]>;

