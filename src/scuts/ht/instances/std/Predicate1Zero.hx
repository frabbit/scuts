package scuts.ht.instances.std;
import scuts.ht.classes.Monoid;
import scuts.ht.classes.Zero;
import scuts.core.Predicates;

using scuts.core.Predicates;

class Predicate1Zero<X> implements Zero<X->Bool>
{
  public function new () {}
  
  
  public inline function zero ():X->Bool 
  {
    return Predicates.constTrue1;
  }
}
