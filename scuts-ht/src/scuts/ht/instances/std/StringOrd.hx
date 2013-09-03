package scuts.ht.instances.std;

import scuts.ht.classes.Ord;
import scuts.ht.classes.OrdAbstract;
import scuts.ht.instances.std.StringEq;

class StringOrd extends OrdAbstract<String> {
  
  public function new (eq) super(eq);
  
  override public inline function lessOrEq (a:String, b:String):Bool {
    return a <= b;
  }
}
