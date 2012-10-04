package hots.instances;


import hots.classes.Monoid;
import hots.classes.MonoidAbstract;
import hots.instances.Tup2Semigroup;
import scuts.core.types.Tup2;

class Tup2Monoid<A,B> extends MonoidAbstract<Tup2<A,B>>
{
  private var m1:Monoid<A>;
  private var m2:Monoid<B>;
  
  public function new (semi:Tup2Semigroup<A,B>, m1:Monoid<A>, m2:Monoid<B>) {
    this.m1 = m1;
    this.m2 = m2;
    super(semi);
  }
  
  override public inline function empty ():Tup2<A,B> 
  {
    return Tup2.create(m1.empty(), m2.empty());
  }
}
