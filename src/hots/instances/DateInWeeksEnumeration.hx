package hots.instances;
import hots.classes.Enumeration;
import hots.classes.EnumerationAbstract;



class DateInWeeksEnumeration {
  
  static var instance;
  
  static function get ()
  {
    if (instance == null) instance = new DateInWeeksEnumerationImpl();
    return instance;
  }
  
}

private class DateInWeeksEnumerationImpl extends EnumerationAbstract<Date>{
  
  
  public function new () {}
  
  override public inline function fromEnum (d:Date):Int {
    return Math.floor(d.getTime()/(1000.0*60.0*60.0*24.0*7.0)+(1.0/24.0));
  }
  
  override public inline function toEnum (i:Int):Date {
    return Date.fromTime(i*(1000.0*60.0*60.0*24.0*7.0) - (1000.0*60.0*60.0*1.0));
  }
}