package hots.instances;
import hots.classes.Monoid;
import hots.classes.MonoidAbstract;
import hots.classes.SemigroupAbstract;

using scuts.core.extensions.Predicates;

class Predicate1Semigroup<X> extends SemigroupAbstract<X->Bool>
{
  public function new () {}
  
  override public inline function append (a:X->Bool, b:X->Bool):X->Bool 
  {
    return a.and(b);
  }
  
}
