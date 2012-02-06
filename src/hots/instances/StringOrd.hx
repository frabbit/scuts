package hots.instances;

import hots.classes.Ord;
import hots.classes.OrdAbstract;
import hots.instances.StringEq;

class StringOrd {
  
  static var instance:StringOrdImpl;
  
  public static function get ()
  {
    if (instance == null) instance = new StringOrdImpl();
    return instance;
  }
  
}

private class StringOrdImpl extends OrdAbstract<String> {
  
  public function new () super(StringEq.get())
  
  override public inline function lessOrEq (a:String, b:String):Bool {
    return a <= b;
  }
}