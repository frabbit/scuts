package scuts.ht.instances.std;

import scuts.ht.classes.Eq;
import scuts.ht.classes.EqAbstract;
import scuts.core.Tuples;



class Tup2Eq<A,B> extends EqAbstract<Tup2<A,B>> 
{
  var eq1:Eq<A>;
  var eq2:Eq<B>;
  
  public function new (eq1:Eq<A>, eq2:Eq<B>) 
  {
    this.eq1 = eq1;
    this.eq2 = eq2;
  }
  
  override public inline function eq  (a:Tup2<A,B>, b:Tup2<A,B>):Bool 
  {
    return Tup2s.eq(a, b, eq1.eq, eq2.eq);
  }
  
}
