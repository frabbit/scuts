package hots.instances;

import hots.classes.Eq;
import hots.classes.EqAbstract;


class ArrayEqImpl<T> extends EqAbstract<Array<T>> {
  
  var eqT:Eq<T>;
  
  public function new (eqT:Eq<T>) 
  {
    this.eqT = eqT;
  }
  
  override public function eq  (a:Array<T>, b:Array<T>):Bool {
    if (a.length != b.length) return false;
    for ( i in 0...a.length) {
      if (!eqT.eq(a[i], b[i])) return false;
    }
    return true;
  }
  
}

typedef ArrayEq = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(ArrayEqImpl)]>;