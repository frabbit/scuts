package hots.instances;
import hots.classes.CollectionAbstract;
import hots.classes.Eq;
import hots.In;


using hots.box.ArrayBox;

class ArrayOfCollection extends CollectionAbstract<Array<In>>
{
  
  public function new () {}
  override public function each <A>(of:ArrayOf<A>, f:A->Void):Void {
    for (e in of.unbox()) {
      f(e);
    }
  }
  override public inline function size <A>(of:ArrayOf<A>):Int return of.unbox().length
  override public function insert <A>(of:ArrayOf<A>, val:A):ArrayOf<A> {
    var a = [];
    for (e in of.unbox()) {
      a.push(e);
    }
    a.push(val);
    return a.box();
  }
  
  override public function remove <A>(of:ArrayOf<A>, f:A->Bool):ArrayOf<A> {
    var a = [];
    for (e in of.unbox()) {
      if (!f(e)) a.push(e);
    }
    return a.box();
  }
  
  override public function removeElem <A>(of:ArrayOf<A>, elem:A, equals:Eq<A>):ArrayOf<A> {
    var a = [];
    for (e in of.unbox()) {
      if (!equals.eq(e, elem)) a.push(e);
    }
    return a.box();
  }
  
}
