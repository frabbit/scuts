package hots.instances;
import hots.classes.Monoid;
import hots.classes.Semigroup;

using scuts.core.Predicates;

class Predicate1Semigroup<X> implements Semigroup<X->Bool>
{
  public function new () {}
  
  public inline function append (a:X->Bool, b:X->Bool):X->Bool 
  {
    return a.and(b);
  }
  
}
