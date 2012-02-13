package hots.classes;
import hots.Of;
import hots.TC;

interface Collection<M> implements TC
{
  public function forEach <A>(coll:Of<M,A>, f:A->Void):Void;
  public function size <A>(coll:Of<M,A>):Int;
  public function insert <A>(coll:Of<M,A>, val:A):Of<M,A>;
  public function remove <A>(coll:Of<M,A>, f:A->Bool):Of<M,A>;
  public function removeElem <A>(coll:Of<M,A>, elem:A, equals:Eq<A>):Of<M,A>;
}


