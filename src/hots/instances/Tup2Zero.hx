package hots.instances;


import hots.classes.Monoid;
import hots.classes.Zero;
import hots.instances.Tup2Semigroup;
import scuts.core.Tup2;

class Tup2Zero<A,B> implements Zero<Tup2<A,B>>
{
  private var m1:Zero<A>;
  private var m2:Zero<B>;
  
  public function new (m1:Zero<A>, m2:Zero<B>) {
    this.m1 = m1;
    this.m2 = m2;
  }
  
  public inline function zero ():Tup2<A,B> 
  {
    return Tup2.create(m1.zero(), m2.zero());
  }
}
