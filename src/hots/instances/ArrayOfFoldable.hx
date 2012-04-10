package hots.instances;
import hots.classes.FoldableAbstract;
import hots.In;
import scuts.core.extensions.ArrayExt;
import hots.classes.Foldable;

using hots.box.ArrayBox;


class ArrayOfFoldable extends FoldableAbstract<Array<In>> 
{
  public function new () {}
  
  override public inline function foldRight <A,B>(of:ArrayOf<A>, b:B, f:A->B->B):B  {
    return ArrayExt.foldRight(of.unbox(), f, b);
  }
  
  override public inline function foldLeft <A,B>(of:ArrayOf<B>, b:A, f:A->B->A):A {
    return ArrayExt.foldLeft(of.unbox(), f, b);
  }
  
}