package hots.instances;

import hots.classes.Ord;
import hots.classes.OrdAbstract;
import hots.instances.StringEq;

class StringOrdImpl extends OrdAbstract<String> {
  
  public function new () super(StringEq.get())
  
  override public inline function lessOrEq (a:String, b:String):Bool {
    return a <= b;
  }
}

typedef StringOrd = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(StringOrdImpl)]>;