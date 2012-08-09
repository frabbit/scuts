package hots.classes;
import hots.Of;
import scuts.Scuts;

/**
 * ...
 * @author 
 */

class CollectionAbstract<M> implements Collection<M>
{

  public function each <A>(coll:Of<M,A>, f:A->Void):Void return Scuts.abstractMethod()
  
  public function size <A>(coll:Of<M,A>):Int return Scuts.abstractMethod()
  
  public function insert <A>(coll:Of<M,A>, val:A):Of<M,A> return Scuts.abstractMethod()
  
  public function append <A>(of:Of<M,A>, val:A):Of<M,A> return Scuts.abstractMethod()
  
  public function remove <A>(coll:Of<M,A>, f:A->Bool):Of<M,A> return Scuts.abstractMethod()
  
  public function removeElem <A>(coll:Of<M,A>, elem:A, equals:Eq<A>):Of<M,A> {
    return remove(coll, function (e) return equals.eq(e, elem));
  }
  
}