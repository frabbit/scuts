package hots.instances;


import hots.classes.Monoid;
import hots.classes.MonoidAbstract;
import hots.classes.Semigroup;
import hots.classes.SemigroupAbstract;
import hots.TC;

import scuts.core.types.Tup2;

class Tup2Semigroup<A,B> extends SemigroupAbstract<Tup2<A,B>> 
{
  private var s1:Semigroup<A>;
  private var s2:Semigroup<B>;
  
  public function new (s1:Semigroup<A>, s2:Semigroup<B>) 
  {
    this.s1 = s1;
    this.s2 = s2;
  }
  
  override public inline function append (a:Tup2<A,B>, b:Tup2<A,B>):Tup2<A,B> 
  {
    return Tup2.create(s1.append(a._1, b._1), s2.append(a._2, b._2));
  }
  
}
