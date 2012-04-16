package hots.instances;

import hots.classes.FoldableAbstract;
import hots.In;
import scuts.core.extensions.Iterables;

using hots.macros.Box;

class ListOfFoldable extends FoldableAbstract<List<In>> 
{
  public function new () {}

  override public inline function foldRight <A,B>(of:ListOf<A>, b:B, f:A->B->B):B  {
    return Iterables.foldRight(of.unbox(), f, b);
  }
   
  override public inline function foldLeft <A,B>(of:ListOf<B>, b:A, f:A->B->A):A {
    return Iterables.foldLeft(of.unbox(), f, b);
  }
  
}
