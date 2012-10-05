package hots.instances;

import hots.classes.Monoid;
import hots.classes.Zero;



class Function0Zero<A> implements Zero<Void->A>
{
  
  var zeroA:Zero<A>;
  
  public function new (zeroA:Zero<A>) {
    
    this.zeroA = zeroA;
  }
  
  public inline function zero ():Void->A 
  {
    return zeroA.zero;
  }
}
