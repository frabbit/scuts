package hots.classes;
import scuts.Scuts;



@:tcAbstract class MonoidAbstract<A> implements Monoid<A>
{
  public function append (a:A, b:A):A return Scuts.abstractMethod()
  public function empty ():A  return Scuts.abstractMethod()
  
  public function concatArray (v:Array<A>):A {
    var res = empty();
    for (e in v) {
      res = append(res, e);
    }
    return res;
  }
}

