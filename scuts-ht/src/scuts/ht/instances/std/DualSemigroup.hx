package scuts.ht.instances.std;
using scuts.core.Functions;

import scuts.ht.classes.Monoid;
import scuts.ht.classes.Semigroup;


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
