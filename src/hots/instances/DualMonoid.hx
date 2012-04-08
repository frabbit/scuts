package hots.instances;
using scuts.core.extensions.FunctionExt;

import hots.classes.Monoid;
import hots.classes.MonoidAbstract;


class DualMonoid<T> extends MonoidAbstract<T>
{
  var monoid:Monoid<T>;
  
  public function new (m:Monoid<T>) 
    this.monoid = m
  
  override public inline function append (a:T, b:T):T {
    return monoid.append(b, a);
  }
  
  override public inline function empty ():T {
    return monoid.empty();
  }
}
