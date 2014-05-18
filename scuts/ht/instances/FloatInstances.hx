
package scuts.ht.instances;

import scuts.core.Ordering;

import scuts.ht.classes.*;

using scuts.core.Floats;

class FloatInstances {

	@:implicit @:noUsing
	public static var eq:Eq<Float> = new FloatEq();

  @:implicit @:noUsing
  public static var show:Show<Float> = new FloatShow();


}

class FloatEq extends EqAbstract<Float>
{
  public function new () {}

  override public inline function eq (a:Float, b:Float):Bool return Floats.eq(a, b);
}

class FloatOrd extends OrdAbstract<Float>
{

  public function new (eq:Eq<Float>)
  {
    super(eq);
  }

  override public inline function lessOrEq (a:Float, b:Float):Bool
  {
    return a <= b;
  }

  override public inline function less (a:Float, b:Float):Bool
  {
    return a < b;
  }

  override public inline function greater (a:Float, b:Float):Bool
  {
    return a > b;
  }

  override public inline function greaterOrEq (a:Float, b:Float):Bool
  {
    return a >= b;
  }

  override public inline function min (a:Float, b:Float):Float
  {
    return a < b ? a : b;
  }
  override public inline function max (a:Float, b:Float):Float
  {
    return a > b ? a : b;
  }

  override public inline function compare (a:Float, b:Float):Ordering
  {
    return
      if (a < b)      Ordering.LT
      else if (a > b) Ordering.GT
      else            Ordering.EQ;
  }
}

class FloatShow implements Show<Float>
{
  public function new () {}

  public inline function show (v:Float):String
  {
    return Std.string(v);
  }
}
