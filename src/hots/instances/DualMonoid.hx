package hots.instances;
using scuts.core.extensions.Functions;

import hots.classes.Monoid;
import hots.classes.MonoidAbstract;


class DualMonoid<T> extends MonoidAbstract<T>
{
  var monoid:Monoid<T>;
  
  public function new (monoid:Monoid<T>) 
  {
    super(DualSemigroup.get(monoid));
    this.monoid = monoid;
  }

  override public inline function empty ():T 
  {
    return monoid.empty();
  }
}
