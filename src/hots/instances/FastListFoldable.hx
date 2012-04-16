package hots.instances;

import haxe.FastList;
import hots.classes.FoldableAbstract;
import hots.In;
import scuts.core.extensions.Iterables;


using hots.macros.Box;

class FastListFoldable extends FoldableAbstract<FastList<In>>
{
  public function new () {}
  
  override public inline function foldRight <A,B>(of:FastListOf<A>, b:B, f:A->B->B):B  {
    return Iterables.foldRight(of.unbox(), f, b);
  }
   
  override public inline function foldLeft <A,B>(of:FastListOf<B>, b:A, f:A->B->A):A {
    return Iterables.foldLeft(of.unbox(), f, b);
  }
  
}
