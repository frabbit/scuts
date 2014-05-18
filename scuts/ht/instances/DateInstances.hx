
package scuts.ht.instances;

import scuts.core.Ordering;

import scuts.ht.classes.*;

class DateInstances {

	@:implicit @:noUsing
	public static function eq (floatEq:Eq<Float>):Eq<Date> return new DateEq(floatEq);

	@:implicit @:noUsing
	public static function ord (floatOrd:Ord<Float>):Ord<Date> return new DateOrd(eq(floatOrd), floatOrd);
}

class DateEq extends EqAbstract<Date>
{
  var floatEq:Eq<Float>;

  public function new (floatEq)
  {
    this.floatEq = floatEq;
  }

  override public inline function eq (a:Date, b:Date):Bool
  {
    return floatEq.eq(a.getTime(), b.getTime());
  }

}

class DateOrd extends OrdAbstract<Date>
{
  var floatOrd:Ord<Float>;

  public function new (eq:Eq<Date>, floatOrd:Ord<Float>)
  {
    super(eq);
    this.floatOrd = floatOrd;
  }

  override public function less (a:Date, b:Date):Bool
  {
    return floatOrd.less(a.getTime(), b.getTime());
  }

  override public function compare (a:Date, b:Date):Ordering
  {
    return floatOrd.compare(a.getTime(), b.getTime());
  }
}