package hots.instances;


import hots.classes.EqAbstract;
import scuts.core.extensions.IntExt;

class IntEqImpl extends EqAbstract<Int> {
  
  public function new () {}
  
  override public inline function eq (a:Int, b:Int):Bool return IntExt.eq(a,b)
  
}

typedef IntEq = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(IntEqImpl)]>;