package hots.instances;
import hots.classes.Monoid;
import hots.classes.MonoidAbstract;
import scuts.core.extensions.Predicates;

using scuts.core.extensions.Predicates;

class Predicate1Monoid<X> extends MonoidAbstract<X->Bool>
{
  public function new () super(Predicate1Semigroup.get())
  
  
  override public inline function empty ():X->Bool 
  {
    return Predicates.constTrue0;
  }
}
