package hots.instances;

import hots.classes.Eq;
import hots.classes.EqAbstract;

class BoolEq extends EqAbstract<Bool> {
  
  public function new () {}

  override public function eq (a:Bool, b:Bool):Bool {
    return a == b;
  }
  
}
