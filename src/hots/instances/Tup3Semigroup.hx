package hots.instances;


import hots.classes.Monoid;
import hots.classes.Semigroup;
import scuts.core.types.Tup3;

import scuts.core.types.Tup2;

class Tup3Semigroup<A,B,C> implements Semigroup<Tup3<A,B,C>>
{
  private var s1:Semigroup<A>;
  private var s2:Semigroup<B>;
  private var s3:Semigroup<C>;
  
  public function new (s1:Semigroup<A>, s2:Semigroup<B>, s3:Semigroup<C>) 
  {
    this.s1 = s1;
    this.s2 = s2;
    this.s3 = s3;
  }
  
  public inline function append (a:Tup3<A,B,C>, b:Tup3<A,B,C>):Tup3<A,B,C> 
  {
    return Tup3.create(s1.append(a._1, b._1), s2.append(a._2, b._2), s3.append(a._3, b._3));
  }
  
}
