package scuts1.instances.std;
import scuts1.classes.FoldableAbstract;
import scuts1.core.In;
import scuts1.instances.std.ArrayOf;
import scuts.core.Arrays;


class ArrayFoldable extends FoldableAbstract<Array<In>> 
{
  public function new () {}
  
  override public inline function foldRight <A,B>(of:ArrayOf<A>, b:B, f:A->B->B):B  
  {
    return Arrays.foldRight(of, b, f);
  }
  
  override public inline function foldLeft <A,B>(of:ArrayOf<B>, b:A, f:A->B->A):A 
  {
    return Arrays.foldLeft(of, b, f);
  }
  
}