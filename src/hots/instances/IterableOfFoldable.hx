package hots.instances;

import hots.classes.FoldableAbstract;
import hots.In;
import scuts.core.extensions.IterableExt;
import hots.classes.Foldable;

using hots.macros.Box;

class IterableOfFoldable extends FoldableAbstract<Iterable<In>> 
{
  public function new () {}
  
  
  override public inline function foldRight <A,B>(of:IterableOf<A>, b:B, f:A->B->B):B  {
    return IterableExt.foldRight(of.unbox(), f, b);
  }
   
  override public inline function foldLeft <A,B>(of:IterableOf<B>, b:A, f:A->B->A):A {
    return IterableExt.foldLeft(of.unbox(), f, b);
  }
  
}
