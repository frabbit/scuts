package hots.instances;

import hots.classes.Eq;
import hots.classes.Ord;
import hots.classes.OrdAbstract;
import hots.instances.DateEq;
import hots.instances.FloatOrd;
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
