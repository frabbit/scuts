
package scuts.ht.instances;

import scuts.ht.classes.*;
import scuts.core.Ordering;
using scuts.core.Ints;

class IntInstances {

	@:implicit @:noUsing
	public static var eq:Eq<Int> = new IntEq();

  @:implicit @:noUsing
  public static var show:Show<Int> = new IntShow();

  @:implicit @:noUsing
  public static var sumSemigroup:Semigroup<Int> = new IntSumSemigroup();

}

class IntEq extends EqAbstract<Int> {

  public function new () {}

  override public inline function eq (a:Int, b:Int):Bool return Ints.eq(a,b);

}


class IntOrd extends OrdAbstract<Int>
{

  public function new (eq:Eq<Int>) super(eq);

  override public inline function lessOrEq (a:Int, b:Int):Bool
  {
    return a <= b;
  }

  override public inline function less (a:Int, b:Int):Bool
  {
    return a < b;
  }

  override public inline function greater (a:Int, b:Int):Bool
  {
    return a > b;
  }

  override public inline function greaterOrEq (a:Int, b:Int):Bool
  {
    return a >= b;
  }

  override public inline function min (a:Int, b:Int):Int
  {
    return if (a < b) a else b;
  }
  override public inline function max (a:Int, b:Int):Int
  {
    return if (a > b) a else b;
  }

  override public inline function compare (a:Int, b:Int):Ordering
  {
    return if (a < b) Ordering.LT else if (a > b) Ordering.GT else Ordering.EQ;
  }

}

class IntProductSemigroup implements Semigroup<Int>
{
  public function new () {}

  public inline function append (a:Int, b:Int):Int return a * b;

}

class IntProductMonoid extends IntProductSemigroup implements Monoid<Int>
{
	public inline function zero () return 1;
}

class IntShow implements Show<Int>
{
  public function new () {}

  public inline function show (v:Int):String {
    return Std.string(v);
  }
}

class IntSumSemigroup implements Semigroup<Int>
{
  public function new () {}

  public inline function append (a:Int, b:Int):Int
  {
    return a+b;
  }
}

class IntSumMonoid extends IntSumSemigroup implements Monoid<Int>
{
	public inline function zero () return 0;
}