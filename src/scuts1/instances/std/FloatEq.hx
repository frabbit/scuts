package scuts1.instances.std;

import scuts1.classes.Eq;
import scuts1.classes.EqAbstract;
import scuts.core.Floats;

class FloatEq extends EqAbstract<Float> 
{
  public function new () {}

  override public inline function eq (a:Float, b:Float):Bool return Floats.eq(a, b);
}
