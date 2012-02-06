package hots.instances;

import haxe.FastList;
import scuts.core.extensions.IterableExt;
import scuts.core.extensions.IteratorExt;
import hots.classes.Foldable;
import hots.wrapper.Mark;
import hots.wrapper.MVal;

using hots.boxing.BoxFastList;

class FoldableFastList {
  
  public static var get(getInstance, null):FoldableFastListImpl;
  
  static function getInstance ()
  {
    if (get == null) get = new FoldableFastListImpl();
    return get;
  }

}


private class FoldableFastListImpl extends FoldableDefault<MarkFastList>
{
  public function new () {}
  
  override public inline function foldRight <A,B>(f:A->B->B, b:B, value:MValFastList<A>):B  {
    return IterableExt.foldRight(value.unbox(), f, b);
  }
  
  override public inline function foldLeft <A,B>(f:A->B->A, b:A, value:MValFastList<B>):A {
    return IterableExt.foldLeft(value.unbox(), f, b);
  }
  
}