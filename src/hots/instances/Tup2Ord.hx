package hots.instances;

import hots.classes.Eq;
import hots.classes.Ord;
import hots.classes.OrdAbstract;
import scuts.core.types.Ordering;
import scuts.core.types.Tup2;


class Tup2Ord<A,B> extends OrdAbstract<Tup2<A,B>> 
{
  var ord1:Ord<A>;
  var ord2:Ord<B>;
  
  public function new (ord1:Ord<A>, ord2:Ord<B>, eq:Eq<Tup2<A,B>>) 
  {
    super(eq);
    this.ord1 = ord1;
    this.ord2 = ord2;
  }
  
  override public inline function compare  (a:Tup2<A,B>, b:Tup2<A,B>):Ordering 
  {
    return switch (ord1.compare(a._1, b._1) ) {
      case LT: LT;
      case EQ: ord2.compare(a._2, b._2);
      case GT : GT;
    }
  }
  
}
