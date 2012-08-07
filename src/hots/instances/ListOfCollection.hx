package hots.instances;

import hots.classes.CollectionAbstract;
import hots.classes.Eq;
import hots.In;


using hots.box.StdListBox;

class StdListOfCollection extends CollectionAbstract<List<In>>
{
  
  public function new () {}
  override public function each <A>(collOf:StdListOf<A>, f:A->Void):Void {
    for (e in collOf.unbox()) {
      f(e);
    }
  }
  override public inline function size <A>(collOf:StdListOf<A>):Int return collOf.unbox().length
  
  override public function insert <A>(collOf:StdListOf<A>, val:A):StdListOf<A> 
  {
    var a = new List();
    a.push(val);
    for (e in collOf.unbox()) {
      a.push(e);
    }
    
    return a.box();
  }
  
  override public function remove <A>(collOf:StdListOf<A>, f:A->Bool):StdListOf<A> {
    var a = new List();
    for (e in collOf.unbox()) {
      if (!f(e)) a.add(e);
    }
    return a.box();
  }
  
  override public function removeElem <A>(collOf:StdListOf<A>, elem:A, equals:Eq<A>):StdListOf<A> {
    var a = new List();
    for (e in collOf.unbox()) {
      if (!equals.eq(e, elem)) a.add(e);
    }
    return a.box();
  }
}
