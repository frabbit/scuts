package hots.instances;
import hots.classes.CollectionAbstract;
import hots.classes.Eq;
import hots.In;
import scuts.core.extensions.Arrays;

using scuts.core.extensions.Predicates;
using hots.box.ArrayBox;

class ArrayOfCollection extends CollectionAbstract<Array<In>>
{
  
  public function new () { }
  
  override public function each <A>(of:ArrayOf<A>, f:A->Void):Void 
  {
    Arrays.each(of.unbox(), f);
  }
  
  override public inline function size <A>(of:ArrayOf<A>):Int return of.unbox().length
  
  override public function insert <A>(of:ArrayOf<A>, val:A):ArrayOf<A> 
  {
    return Arrays.appendElem(of.unbox(), val).box();
  }
  
  override public function remove <A>(of:ArrayOf<A>, f:A->Bool):ArrayOf<A> 
  {
    return Arrays.filter(of.unbox(), f.not()).box();
  }
  
  override public function removeElem <A>(of:ArrayOf<A>, elem:A, equals:Eq<A>):ArrayOf<A> 
  {
    return Arrays.removeElem(of.unbox(), elem, equals.eq).box();
  }
  
}
