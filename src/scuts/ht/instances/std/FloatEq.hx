package scuts.ht.instances.std;

import scuts.ht.classes.Eq;
import scuts.ht.classes.EqAbstract;
import scuts.core.Floats;

class FloatEq extends EqAbstract<Float> 
{
  public function new () {}

  override public inline function eq (a:Float, b:Float):Bool return Floats.eq(a, b);
}
