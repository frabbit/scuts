package hots.instances;

import hots.classes.FoldableAbstract;
import hots.In;
import scuts.core.extensions.IterableExt;


using hots.instances.ListBox;

class ListOfFoldableImpl extends FoldableAbstract<List<In>> 
{
  public function new () {}
  
  override public inline function foldRight <A,B>(f:A->B->B, b:B, value:ListOf<A>):B  {
    return IterableExt.foldRight(value.unbox(), f, b);
  }
  
  override public inline function foldLeft <A,B>(f:A->B->A, b:A, value:ListOf<B>):A {
    return IterableExt.foldLeft(value.unbox(), f, b);
  }
  
}

typedef ListOfFoldable = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(ListOfFoldableImpl)]>;