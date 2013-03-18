package scuts.ht.instances.std;

import scuts.ht.classes.Eq;
import scuts.ht.classes.EqAbstract;

class BoolEq extends EqAbstract<Bool> {
  
  public function new () {}

  override public inline function eq (a:Bool, b:Bool):Bool return a == b;
}
