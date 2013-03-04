package scuts1.instances.std;
import scuts1.classes.Monoid;
import scuts1.classes.Zero;
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
