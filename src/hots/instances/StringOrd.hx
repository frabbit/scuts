package hots.instances;

import hots.classes.Ord;
import hots.classes.OrdAbstract;
import hots.instances.StringEq;

class StringOrd extends OrdAbstract<String> {
  
  public function new (eq) super(eq)
  
  override public inline function lessOrEq (a:String, b:String):Bool {
    return a <= b;
  }
}
