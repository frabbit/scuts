package hots.instances;

import hots.classes.Eq;
import hots.classes.EqAbstract;
import hots.instances.FloatEq;

class DateEq extends EqAbstract<Date> 
{
  
  public function new () {}

  override public inline function eq (a:Date, b:Date):Bool 
  {
    return FloatEq.get().eq(a.getTime(), b.getTime());
  }
  
  override public inline function notEq (a:Date, b:Date):Bool 
  {
    return FloatEq.get().notEq(a.getTime(), b.getTime());
  }
}
