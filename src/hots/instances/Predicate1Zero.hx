package hots.instances;
import hots.classes.Monoid;
import hots.classes.Zero;
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
