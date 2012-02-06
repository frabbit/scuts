package hots.instances;

import hots.classes.Ord;
import hots.classes.OrdAbstract;
import scuts.core.types.Ordering;

class FloatOrd {
  
  static var instance;
  
  public static function get ()
  {
    if (instance == null) instance = new FloatOrdImpl();
    return instance;
  }
}

private class FloatOrdImpl extends OrdAbstract<Float> {
  
  public function new () { super(FloatEq.get()); }
  
  override public function lessOrEq (a:Float, b:Float):Bool {
    return a <= b;
  }
  
  override public function less (a:Float, b:Float):Bool {
    return a < b;
  }
  
  override public function greater (a:Float, b:Float):Bool {
    return a > b;
  }
  
  override public function greaterOrEq (a:Float, b:Float):Bool {
    return a >= b;
  }
  
  override public function min (a:Float, b:Float):Float {
    return a < b ? a : b;
  }
  override public function max (a:Float, b:Float):Float {
    return a > b ? a : b;
  }
  
  override public function compare (a:Float, b:Float):Ordering {
    return if (a < b) Ordering.LT else if (a > b) Ordering.GT else Ordering.EQ;
  }
  
  override public function compareInt (a:Float, b:Float):Int {
    return if (a < b) -1 else if (a > b) 1 else 0;
  }
}