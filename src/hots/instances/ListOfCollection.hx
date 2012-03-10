package hots.instances;

import hots.classes.CollectionAbstract;
import hots.classes.Eq;
import hots.In;


using hots.instances.ListBox;

class ListOfCollectionImpl extends CollectionAbstract<List<In>>
{
  
  public function new () {}
  override public function forEach <A>(collOf:ListOf<A>, f:A->Void):Void {
    for (e in collOf.unbox()) {
      f(e);
    }
  }
  override public inline function size <A>(collOf:ListOf<A>):Int return collOf.unbox().length
  
  override public function insert <A>(collOf:ListOf<A>, val:A):ListOf<A> 
  {
    var a = new List();
    a.push(val);
    for (e in collOf.unbox()) {
      a.push(e);
    }
    
    return a.box();
  }
  
  override public function remove <A>(collOf:ListOf<A>, f:A->Bool):ListOf<A> {
    var a = new List();
    for (e in collOf.unbox()) {
      if (!f(e)) a.add(e);
    }
    return a.box();
  }
  
  override public function removeElem <A>(collOf:ListOf<A>, elem:A, equals:Eq<A>):ListOf<A> {
    var a = new List();
    for (e in collOf.unbox()) {
      if (!equals.eq(e, elem)) a.add(e);
    }
    return a.box();
  }
}

typedef ListOfCollection = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(ListOfCollectionImpl)]>;