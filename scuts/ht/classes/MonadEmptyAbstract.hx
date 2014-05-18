
package scuts.ht.classes;

class MonadEmptyAbstract<M> implements MonadEmpty<M> {

  public function flatMap<A,B>(val:Of<M,A>, f:A->Of<M,B>):Of<M,B>
  {
    return flatten(map(val, f));
  }
  public function map<A,B>(val:Of<M,A>, f:A->B):Of<M,B>
  {
    var f = function (x:A) return pure(f(x));
    return flatMap(val, f);
  }

  public function flatten<A>(val:Of<M,Of<M,A>>):Of<M,A>
  {
    return flatMap(val, Scuts.id);
  }

  public function pure<A>(val:A):Of<M,A>
  {
    return throw "abstract";
  }

  public function empty<A>():Of<M,A>
  {
    return throw "abstract";
  }

}