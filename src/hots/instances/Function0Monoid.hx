package hots.instances;

import hots.classes.Monoid;
import hots.classes.MonoidAbstract;



class Function0Monoid<A> extends MonoidAbstract<Void->A>
{
  
  var monoidA:Monoid<A>;
  
  public function new (monoidA:Monoid<A>) {
    
    super(Function0Semigroup.get(monoidA));
    
    this.monoidA = monoidA;
  }
  
  override public inline function empty ():Void->A 
  {
    return monoidA.empty;
  }
}
