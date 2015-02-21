package scuts.ht.instances.std;
import scuts.ht.classes.FoldableAbstract;
import scuts.core.Arrays;


class ArrayFoldable extends FoldableAbstract<Array<_>>
{
  public function new () {}

  override public inline function foldRight <A,B>(of:Array<A>, b:B, f:A->B->B):B
  {
    return Arrays.foldRight(of, b, f);
  }

  override public inline function foldLeft <A,B>(of:Array<B>, b:A, f:A->B->A):A
  {
    return Arrays.foldLeft(of, b, f);
  }

}