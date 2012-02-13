package hots.instances;


import hots.classes.EqAbstract;

class IntEqImpl extends EqAbstract<Int> {
  
  public function new () {}
  
  override public inline function eq (a:Int, b:Int):Bool {
    return a == b;
  }
  
}

typedef IntEq = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(IntEqImpl)]>;