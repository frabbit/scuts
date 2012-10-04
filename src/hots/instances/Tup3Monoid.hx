package hots.instances;


import hots.classes.Monoid;
import hots.classes.MonoidAbstract;
import scuts.core.types.Tup3;
import scuts.core.types.Tup3;

import scuts.core.types.Tup2;

class Tup3Monoid<A,B,C> extends MonoidAbstract<Tup3<A,B,C>>
{
  private var m1:Monoid<A>;
  private var m2:Monoid<B>;
  private var m3:Monoid<C>;
  
  public function new (semi, m1:Monoid<A>, m2:Monoid<B>, m3:Monoid<C>) 
  {
    super(semi);
    this.m1 = m1;
    this.m2 = m2;
    this.m3 = m3;
  }
  
  override public inline function empty ():Tup3<A,B,C> 
  {
    return Tup3.create(m1.empty(), m2.empty(), m3.empty());
  }
}
