package hots.instances;

import hots.classes.CollectionAbstract;
import hots.classes.Eq;
import hots.In;


using hots.instances.ListBox;

class ListOfCollectionImpl extends CollectionAbstract<List<In>>
{
  
  public function new () {}
  override public function forEach <A>(coll:ListOf<A>, f:A->Void):Void {
    for (e in coll.unbox()) {
      f(e);
    }
  }
  override public inline function size <A>(coll:ListOf<A>):Int return coll.unbox().length
  override public function insert <A>(coll:ListOf<A>, val:A):ListOf<A> {
    var a = new List();
    for (e in coll.unbox()) {
      a.push(e);
    }
    a.push(val);
    return a.box();
  }
  
  override public function remove <A>(coll:ListOf<A>, f:A->Bool):ListOf<A> {
    var a = new List();
    for (e in coll.unbox()) {
      if (!f(e)) a.add(e);
    }
    return a.box();
  }
  
  override public function removeElem <A>(coll:ListOf<A>, elem:A, equals:Eq<A>):ListOf<A> {
    var a = new List();
    for (e in coll.unbox()) {
      if (!equals.eq(e, elem)) a.add(e);
    }
    return a.box();
  }
}

typedef ListOfCollection = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(ListOfCollectionImpl)]>;