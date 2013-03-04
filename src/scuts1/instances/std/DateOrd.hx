package scuts1.instances.std;

import scuts1.classes.Eq;
import scuts1.classes.Ord;
import scuts1.classes.OrdAbstract;
import scuts1.instances.std.DateEq;
import scuts1.instances.std.FloatOrd;
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
