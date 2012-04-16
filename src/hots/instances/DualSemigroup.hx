package hots.instances;
using scuts.core.extensions.Functions;

import hots.classes.Monoid;
import hots.classes.MonoidAbstract;
import hots.classes.Semigroup;
import hots.classes.SemigroupAbstract;


class DualSemigroup<T> extends SemigroupAbstract<T>
{
  var semi:Semigroup<T>;
  
  public function new (s:Semigroup<T>) 
    this.semi = s
  
  override public inline function append (a1:T, a2:T):T {
    return semi.append(a2, a1);
  }
  
}
