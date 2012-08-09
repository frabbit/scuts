package hots.instances;

import hots.classes.Eq;
import hots.classes.EqAbstract;
import hots.instances.FloatEq;

class DateEq extends EqAbstract<Date> 
{
  var floatEq:FloatEq;
  
  public function new (floatEq) {
    this.floatEq = floatEq;
  }

  override public inline function eq (a:Date, b:Date):Bool 
  {
    return floatEq.eq(a.getTime(), b.getTime());
  }

}
