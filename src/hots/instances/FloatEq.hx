package hots.instances;

import hots.classes.Eq;
import hots.classes.EqAbstract;
import scuts.core.extensions.Floats;

class FloatEq extends EqAbstract<Float> 
{
  public function new () {}

  override public inline function eq (a:Float, b:Float):Bool return Floats.eq(a, b)
}
