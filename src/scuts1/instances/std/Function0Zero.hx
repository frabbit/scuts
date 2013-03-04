package scuts1.instances.std;

import scuts1.classes.Monoid;
import scuts1.classes.Zero;



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
