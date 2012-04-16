package hots.instances;
import hots.classes.FoldableAbstract;
import hots.In;
import scuts.core.extensions.Arrays;
import hots.classes.Foldable;

using hots.box.ArrayBox;


class ArrayOfFoldable extends FoldableAbstract<Array<In>> 
{
  public function new () {}
  
  override public inline function foldRight <A,B>(of:ArrayOf<A>, b:B, f:A->B->B):B  {
    return Arrays.foldRight(of.unbox(), f, b);
  }
  
  override public inline function foldLeft <A,B>(of:ArrayOf<B>, b:A, f:A->B->A):A {
    return Arrays.foldLeft(of.unbox(), f, b);
  }
  
}