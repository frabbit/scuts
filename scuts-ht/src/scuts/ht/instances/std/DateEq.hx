package scuts.ht.instances.std;

import scuts.ht.classes.Eq;
import scuts.ht.classes.EqAbstract;
import scuts.ht.instances.std.FloatEq;

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
