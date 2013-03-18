package scuts.ht.instances.std;
import scuts.ht.classes.Monoid;
import scuts.ht.classes.Semigroup;

using scuts.core.Predicates;

class Predicate1Semigroup<X> implements Semigroup<X->Bool>
{
  public function new () {}
  
  public inline function append (a:X->Bool, b:X->Bool):X->Bool 
  {
    return a.and(b);
  }
  
}
