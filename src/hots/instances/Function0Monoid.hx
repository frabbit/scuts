package hots.instances;

import hots.classes.Monoid;
import hots.classes.MonoidAbstract;



class Function0Monoid<A> extends MonoidAbstract<Void->A>
{
  
  var monoidA:Monoid<A>;
  
  public function new (monoidA:Monoid<A>, semi) {
    
    super(semi);
    
    this.monoidA = monoidA;
  }
  
  override public inline function empty ():Void->A 
  {
    return monoidA.empty;
  }
}
