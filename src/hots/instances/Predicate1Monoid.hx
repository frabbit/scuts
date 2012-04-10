package hots.instances;
import hots.classes.Monoid;
import hots.classes.MonoidAbstract;

using scuts.core.extensions.PredicateExt;

class Predicate1Monoid<X> extends MonoidAbstract<X->Bool>
{
  public function new () super(Predicate1Semigroup.get())
  
  
  override public inline function empty ():X->Bool {
    return function (x) return true;
  }
}
