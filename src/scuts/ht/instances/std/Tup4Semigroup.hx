package scuts.ht.instances.std;


import scuts.ht.classes.Monoid;

import scuts.ht.classes.Semigroup;


import scuts.core.Tup4;

class Tup4Semigroup<A,B,C,D> implements Semigroup<Tup4<A,B,C,D>>
{
  private var s1:Semigroup<A>;
  private var s2:Semigroup<B>;
  private var s3:Semigroup<C>;
  private var s4:Semigroup<D>;
  
  public function new (s1:Semigroup<A>, s2:Semigroup<B>, s3:Semigroup<C>, s4:Semigroup<D>) 
  {
    this.s1 = s1;
    this.s2 = s2;
    this.s3 = s3;
    this.s4 = s4;
  }
  
  public inline function append (a:Tup4<A,B,C,D>, b:Tup4<A,B,C,D>):Tup4<A,B,C,D> 
  {
    return Tup4.create(s1.append(a._1, b._1), s2.append(a._2, b._2), s3.append(a._3, b._3), s4.append(a._4, b._4));
  }
}
