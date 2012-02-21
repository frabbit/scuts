package hots.instances;

import hots.classes.Eq;
import hots.classes.EqAbstract;
import scuts.core.extensions.FloatExt;
import scuts.core.math.MathConstants;

class FloatEqImpl extends EqAbstract<Float> {
  
  public function new () {}

  override public inline function eq (a:Float, b:Float):Bool return FloatExt.eq(a, b)
  
}

typedef FloatEq = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(FloatEqImpl)]>;