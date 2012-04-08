package hots.instances;

import haxe.FastList;
import hots.classes.FoldableAbstract;
import hots.In;
import scuts.core.extensions.IterableExt;


using hots.macros.Box;

class FastListFoldable extends FoldableAbstract<FastList<In>>
{
  public function new () {}
  
  
  
  override public inline function foldRight <A,B>(f:A->B->B, b:B, value:FastListOf<A>):B  {
    return IterableExt.foldRight(value.unbox(), f, b);
  }
   
  
  override public inline function foldLeft <A,B>(f:A->B->A, b:A, value:FastListOf<B>):A {
    return IterableExt.foldLeft(value.unbox(), f, b);
  }
  
}
