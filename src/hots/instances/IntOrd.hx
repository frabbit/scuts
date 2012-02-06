package hots.instances;

import hots.classes.Ord;
import scuts.core.types.Ordering;

class OrdInt {
  
  public static var get(getInstance, null):OrdIntImpl;
  
  static function getInstance ()
  {
    if (get == null) get = new OrdIntImpl(EqInt.get);
    return get;
  }
}

private class OrdIntImpl extends OrdDefault<Int> {
  
  public function new (eq) { super(eq);}
  
  override public function lessOrEq (a:Int, b:Int):Bool {
    return a <= b;
  }
  
  override public function less (a:Int, b:Int):Bool {
    return a < b;
  }
  
  override public function greater (a:Int, b:Int):Bool {
    return a > b;
  }
  
  override public function greaterOrEq (a:Int, b:Int):Bool {
    return a >= b;
  }
  
  override public function min (a:Int, b:Int):Int {
    return a < b ? a : b;
  }
  override public function max (a:Int, b:Int):Int {
    return a > b ? a : b;
  }
  
  override public function compare (a:Int, b:Int):Ordering {
    return if (a < b) Ordering.LT else if (a > b) Ordering.GT else Ordering.EQ;
  }
  
  override public function compareInt (a:Int, b:Int):Int {
    return if (a < b) -1 else if (a > b) 1 else 0;
  }
}
