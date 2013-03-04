package scuts1.instances.std;
import scuts1.classes.Monoid;
import scuts1.classes.Semigroup;

using scuts.core.Predicates;

class Predicate1Semigroup<X> implements Semigroup<X->Bool>
{
  public function new () {}
  
  public inline function append (a:X->Bool, b:X->Bool):X->Bool 
  {
    return a.and(b);
  }
  
}
