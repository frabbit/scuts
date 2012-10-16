package hots.instances;


import hots.classes.Monoid;
import hots.classes.Zero;
import hots.instances.Tup4Semigroup;

import scuts.core.Tup4;

class Tup4Zero<A,B,C,D> implements Zero<Tup4<A,B,C,D>>
{
  private var m1:Zero<A>;
  private var m2:Zero<B>;
  private var m3:Zero<C>;
  private var m4:Zero<D>;
  
  public function new (m1:Zero<A>, m2:Zero<B>, m3:Zero<C>, m4:Zero<D>) 
  {
    this.m1 = m1;
    this.m2 = m2;
    this.m3 = m3;
    this.m4 = m4;
  }

  public inline function zero ():Tup4<A,B,C,D> 
  {
    return Tup4.create(m1.zero(), m2.zero(), m3.zero(), m4.zero());
  }
}
