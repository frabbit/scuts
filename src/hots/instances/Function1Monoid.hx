package hots.instances;

import hots.classes.Monoid;
import hots.classes.MonoidAbstract;
import hots.instances.Function1Semigroup;


class Function1Monoid<A,B> extends MonoidAbstract<A->B>
{
  
  var monoidB:Monoid<B>;
  
  public function new (monoidB:Monoid<B>) 
  {
    super(Function1Semigroup.get(monoidB));
    this.monoidB = monoidB;
  }
  
  override public inline function empty ():A->B 
  {
    return function (a) return monoidB.empty();
  }
}
