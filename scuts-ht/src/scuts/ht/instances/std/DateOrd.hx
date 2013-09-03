package scuts.ht.instances.std;

import scuts.ht.classes.Eq;
import scuts.ht.classes.Ord;
import scuts.ht.classes.OrdAbstract;
import scuts.ht.instances.std.DateEq;
import scuts.ht.instances.std.FloatOrd;
import scuts.core.Ordering;


class DateOrd extends OrdAbstract<Date> 
{
  var floatOrd:Ord<Float>;
  
  public function new (eq:Eq<Date>, floatOrd:Ord<Float>) 
  {
    super(eq);
    this.floatOrd = floatOrd;
  }
  
  override public function less (a:Date, b:Date):Bool 
  {
    return floatOrd.less(a.getTime(), b.getTime());
  }
  
  override public function compare (a:Date, b:Date):Ordering 
  {
    return floatOrd.compare(a.getTime(), b.getTime());
  }
  
  override public inline function compareInt (a:Date, b:Date):Int 
  {
    return floatOrd.compareInt(a.getTime(), b.getTime());
  }
}
