package hots.instances;

import hots.classes.Monoid;
import hots.classes.Zero;
import hots.instances.Function1Semigroup;


class Function1Zero<A,B> implements Zero<A->B>
{
  var zeroB:Zero<B>;
  
  public function new (zeroB:Zero<B>) 
  {
    this.zeroB = zeroB;
  }
  
  public inline function zero ():A->B 
  {
    return function (a) return zeroB.zero();
  }
}
