package scuts1.instances.std;

import scuts1.classes.Eq;
import scuts1.classes.EqAbstract;
import scuts1.instances.std.FloatEq;

class DateEq extends EqAbstract<Date> 
{
  var floatEq:Eq<Float>;
  
  public function new (floatEq) 
  {
    this.floatEq = floatEq;
  }

  override public inline function eq (a:Date, b:Date):Bool 
  {
    return floatEq.eq(a.getTime(), b.getTime());
  }

}
