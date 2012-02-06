package hots.instances;

import hots.classes.Eq;
import hots.classes.EqAbstract;

class BoolEq  {
  static var instance;
  
  public static function get ()
  {
    if (instance == null) instance = new BoolEqImpl();
    return instance;
  }
}

private class BoolEqImpl extends EqAbstract<Bool> {
  
  public function new () {}

  override public function eq (a:Bool, b:Bool):Bool {
    return a == b;
  }
  
}