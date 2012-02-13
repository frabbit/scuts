package hots.instances;

import hots.classes.Ord;
import hots.classes.OrdAbstract;



class EnumByIndexOrdImpl extends OrdAbstract<Enum<Dynamic>> {
  
  public function new () super(EnumByIndexEq.get())

  override public function lessOrEq (a:Enum<Dynamic>, b:Enum<Dynamic>):Bool {
    return Type.enumIndex(a) <= Type.enumIndex(b);
  }
}

typedef EnumByIndexOrd = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(EnumByIndexOrdImpl)]>;