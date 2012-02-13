package hots.instances;

import hots.classes.Ord;
import hots.classes.OrdAbstract;
import scuts.core.types.Ordering;

class IntOrdImpl extends OrdAbstract<Int> {
  
  public function new () super(IntEq.get())
  
  override public inline function lessOrEq (a:Int, b:Int):Bool {
    return a <= b;
  }
  
  override public inline function less (a:Int, b:Int):Bool {
    return a < b;
  }
  
  override public inline function greater (a:Int, b:Int):Bool {
    return a > b;
  }
  
  override public inline function greaterOrEq (a:Int, b:Int):Bool {
    return a >= b;
  }
  
  override public inline function min (a:Int, b:Int):Int {
    return a < b ? a : b;
  }
  override public inline function max (a:Int, b:Int):Int {
    return a > b ? a : b;
  }
  
  override public inline function compare (a:Int, b:Int):Ordering {
    return if (a < b) Ordering.LT else if (a > b) Ordering.GT else Ordering.EQ;
  }
  
  override public inline function compareInt (a:Int, b:Int):Int {
    return if (a < b) -1 else if (a > b) 1 else 0;
  }
}

typedef IntOrd = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(IntOrdImpl)]>;
