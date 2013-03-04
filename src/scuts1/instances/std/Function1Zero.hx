package scuts1.instances.std;

import scuts1.classes.Monoid;
import scuts1.classes.Zero;
import scuts1.instances.std.Function1Semigroup;


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
