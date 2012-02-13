package hots.instances;

import hots.classes.Ord;
import hots.classes.OrdAbstract;
import hots.instances.DateEq;
import hots.instances.FloatOrd;
import scuts.core.types.Ordering;


private class DateOrdImpl extends OrdAbstract<Date> {

  public function new (eq) { super(eq);}
  
  override public function less (a:Date, b:Date):Bool {
    return FloatOrd.get().less(a.getTime(), b.getTime());
  }
  
  override public function compare (a:Date, b:Date):Ordering {
    return FloatOrd.get().compare(a.getTime(), b.getTime());
  }
  
  override public inline function compareInt (a:Date, b:Date):Int {
    return FloatOrd.get().compareInt(a.getTime(), b.getTime());
  }
}

typedef DateOrd = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(DateOrdImpl)]>;
