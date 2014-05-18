package scuts.ht.instances;
using scuts.core.Functions;

import scuts.ht.classes.Monoid;
import scuts.ht.classes.Semigroup;

class DualInstances {
	@:noUsing
	public static function monoid <T>(monoidT:Monoid<T>):Monoid<T> return new DualMonoid(monoidT);

	@:noUsing
	public static function semigroup <T>(semiT:Semigroup<T>):Semigroup<T> return new DualSemigroup(semiT);
}

class DualMonoid<T> extends DualSemigroup<T> implements Monoid<T>
{
  var m : Monoid<T>;

	public function new (m:Monoid<T>) {
		super(m);
    this.m = m;
	}

	public function zero () return m.zero();
}

class DualSemigroup<T> implements Semigroup<T>
{

  var semi:Semigroup<T>;

  public function new (s:Semigroup<T>)
  {
    this.semi = s;
  }

  public inline function append (a1:T, a2:T):T
  {
    return semi.append(a2, a1);
  }

}
