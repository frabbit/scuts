package hots.instances;

import hots.classes.Eq;
import hots.classes.EqAbstract;
import hots.instances.IntEq;

class EnumByIndexEqImpl extends EqAbstract<Enum<Dynamic>> {
  
  public function new () {}

  override public function eq (a:Enum<Dynamic>, b:Enum<Dynamic>):Bool {
    return IntEq.get().eq(Type.enumIndex(a),Type.enumIndex(b));
  }
}

typedef EnumByIndexEq = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(EnumByIndexEqImpl)]>;