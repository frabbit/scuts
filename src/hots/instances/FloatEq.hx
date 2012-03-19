package hots.instances;

import hots.classes.Eq;
import hots.classes.EqAbstract;
import scuts.core.extensions.FloatExt;
import scuts.core.math.MathConstants;

class FloatEq extends EqAbstract<Float> {
  
  public function new () {}

  override public inline function eq (a:Float, b:Float):Bool return FloatExt.eq(a, b)
  
}
