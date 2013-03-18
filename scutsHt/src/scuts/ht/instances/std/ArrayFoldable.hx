package scuts.ht.instances.std;
import scuts.ht.classes.FoldableAbstract;
import scuts.ht.core.In;
import scuts.ht.instances.std.ArrayOf;
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