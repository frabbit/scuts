package hots.instances;
import hots.classes.FoldableAbstract;
import hots.In;
import scuts.core.extensions.ArrayExt;
import hots.classes.Foldable;

using hots.macros.Box;


class ArrayOfFoldable extends FoldableAbstract<Array<In>> 
{
  public function new () {}
  
  override public inline function foldRight <A,B>(f:A->B->B, b:B, value:ArrayOf<A>):B  {
    return ArrayExt.foldRight(value.unbox(), f, b);
  }
  
  override public inline function foldLeft <A,B>(f:A->B->A, b:A, value:ArrayOf<B>):A {
    return ArrayExt.foldLeft(value.unbox(), f, b);
  }
  
}