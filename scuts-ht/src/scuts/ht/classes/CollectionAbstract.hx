package scuts.ht.classes;
import scuts.ht.core.Of;
import scuts.Scuts;


class CollectionAbstract<M> implements Collection<M>
{

  public function each <A>(coll:M<A>, f:A->Void):Void return Scuts.abstractMethod();

  public function size <A>(coll:M<A>):Int return Scuts.abstractMethod();

  public function insert <A>(coll:M<A>, val:A):M<A> return Scuts.abstractMethod();

  public function append <A>(of:M<A>, val:A):M<A> return Scuts.abstractMethod();

  public function remove <A>(coll:M<A>, f:A->Bool):M<A> return Scuts.abstractMethod();

  public function removeElem <A>(coll:M<A>, elem:A, equals:Eq<A>):M<A> {
    return remove(coll, function (e) return equals.eq(e, elem));
  }

}