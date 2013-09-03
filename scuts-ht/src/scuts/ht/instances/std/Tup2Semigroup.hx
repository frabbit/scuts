package scuts.ht.instances.std;


import scuts.ht.classes.Monoid;
import scuts.ht.classes.Semigroup;


import scuts.core.Tuples;

class Tup2Semigroup<A,B> implements Semigroup<Tup2<A,B>> 
{
  private var s1:Semigroup<A>;
  private var s2:Semigroup<B>;
  
  public function new (s1:Semigroup<A>, s2:Semigroup<B>) 
  {
    this.s1 = s1;
    this.s2 = s2;
  }
  
  public inline function append (a:Tup2<A,B>, b:Tup2<A,B>):Tup2<A,B> 
  {
    return Tup2.create(s1.append(a._1, b._1), s2.append(a._2, b._2));
  }
  
}
