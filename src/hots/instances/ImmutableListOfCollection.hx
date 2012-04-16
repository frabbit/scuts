package hots.instances;

import hots.classes.CollectionAbstract;
import hots.classes.Eq;
import hots.In;
import hots.instances.ImmutableListOf;
import scuts.data.List;

using scuts.data.Lists;

using hots.box.ImmutableListBox;

class ImmutableListOfCollection extends CollectionAbstract<scuts.data.List<In>>
{
  
  public function new () {}
  override public function each <A>(collOf:ImmutableListOf<A>, f:A->Void):Void {
    collOf.unbox().each(f);
  }
  
  override public inline function size <A>(collOf:ImmutableListOf<A>):Int return collOf.unbox().size()
  
  override public inline function insert <A>(collOf:ImmutableListOf<A>, val:A):ImmutableListOf<A> 
  {
    return collOf.unbox().cons(val).box();
  }
  
  override public inline function remove <A>(collOf:ImmutableListOf<A>, f:A->Bool):ImmutableListOf<A> {
    return collOf.unbox().filter(f).box();
  }
  
  override public function removeElem <A>(collOf:ImmutableListOf<A>, elem:A, equals:Eq<A>):ImmutableListOf<A> {
    return collOf.unbox().filter(function (e) return equals.eq(e, elem)).box();
  }
}
