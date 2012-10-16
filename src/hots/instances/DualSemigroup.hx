package hots.instances;
using scuts.core.Functions;

import hots.classes.Monoid;
import hots.classes.Semigroup;


class DualSemigroup<T> implements Semigroup<T>
{
  var semi:Semigroup<T>;
  
  public function new (s:Semigroup<T>) 
  {
    this.semi = s;
  }
  
  public inline function append (a1:T, a2:T):T 
  {
    return semi.append(a2, a1);
  }
  
}
