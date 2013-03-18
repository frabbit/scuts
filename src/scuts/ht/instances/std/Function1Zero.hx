package scuts.ht.instances.std;

import scuts.ht.classes.Monoid;
import scuts.ht.classes.Zero;
import scuts.ht.instances.std.Function1Semigroup;


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
