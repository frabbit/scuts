package hots.instances;
import hots.classes.CollectionAbstract;
import hots.classes.Eq;
import hots.In;


using hots.macros.Box;

class ArrayOfCollection extends CollectionAbstract<Array<In>>
{
  
  public function new () {}
  override public function forEach <A>(coll:ArrayOf<A>, f:A->Void):Void {
    for (e in coll.unbox()) {
      f(e);
    }
  }
  override public inline function size <A>(coll:ArrayOf<A>):Int return coll.unbox().length
  override public function insert <A>(coll:ArrayOf<A>, val:A):ArrayOf<A> {
    var a = [];
    for (e in coll.unbox()) {
      a.push(e);
    }
    a.push(val);
    return a.box();
  }
  
  override public function remove <A>(coll:ArrayOf<A>, f:A->Bool):ArrayOf<A> {
    var a = [];
    for (e in coll.unbox()) {
      if (!f(e)) a.push(e);
    }
    return a.box();
  }
  
  override public function removeElem <A>(coll:ArrayOf<A>, elem:A, equals:Eq<A>):ArrayOf<A> {
    var a = [];
    for (e in coll.unbox()) {
      if (!equals.eq(e, elem)) a.push(e);
    }
    return a.box();
  }
  
}
