package scuts1.instances.std;

import scuts1.classes.Eq;
import scuts1.classes.EqAbstract;

class BoolEq extends EqAbstract<Bool> {
  
  public function new () {}

  override public inline function eq (a:Bool, b:Bool):Bool return a == b;
}
