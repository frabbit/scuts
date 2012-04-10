package hots.instances;


import hots.classes.Monoid;
import hots.classes.MonoidAbstract;

import scuts.core.types.Tup4;

class Tup4Monoid<A,B,C,D> extends MonoidAbstract<Tup4<A,B,C,D>>
{
  private var m1:Monoid<A>;
  private var m2:Monoid<B>;
  private var m3:Monoid<C>;
  private var m4:Monoid<D>;
  
  public function new (m1:Monoid<A>, m2:Monoid<B>, m3:Monoid<C>, m4:Monoid<D>) 
  {
    this.m1 = m1;
    this.m2 = m2;
    this.m3 = m3;
    this.m4 = m4;
  }
  
  override public inline function append (a:Tup4<A,B,C,D>, b:Tup4<A,B,C,D>):Tup4<A,B,C,D> 
  {
    return Tup4.create(m1.append(a._1, b._1), m2.append(a._2, b._2), m3.append(a._3, b._3), m4.append(a._4, b._4));
  }
  
  override public inline function empty ():Tup4<A,B,C,D> 
  {
    return Tup4.create(m1.empty(), m2.empty(), m3.empty(), m4.empty());
  }
}
