package scuts1.instances.std;

import scuts1.classes.Ord;
import scuts1.classes.OrdAbstract;
import scuts1.instances.std.StringEq;

class StringOrd extends OrdAbstract<String> {
  
  public function new (eq) super(eq);
  
  override public inline function lessOrEq (a:String, b:String):Bool {
    return a <= b;
  }
}
