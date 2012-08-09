package hots.instances;

import hots.classes.Eq;
import hots.classes.Ord;
import hots.classes.OrdAbstract;
import hots.instances.DateEq;
import hots.instances.FloatOrd;
import scuts.core.types.Ordering;


class DateOrd extends OrdAbstract<Date> 
{
  var floatEq:FloatOrd;
  
  public function new (eq:Eq<Date>, floatEq:FloatOrd) 
  {
    super(eq);
    this.floatEq = floatEq;
  }
  
  override public function less (a:Date, b:Date):Bool 
  {
    return floatEq.less(a.getTime(), b.getTime());
  }
  
  override public function compare (a:Date, b:Date):Ordering 
  {
    return floatEq.compare(a.getTime(), b.getTime());
  }
  
  override public inline function compareInt (a:Date, b:Date):Int 
  {
    return floatEq.compareInt(a.getTime(), b.getTime());
  }
}
