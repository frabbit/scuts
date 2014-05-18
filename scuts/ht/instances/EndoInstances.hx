package scuts.ht.instances;
import scuts.ht.classes.Monoid;
import scuts.ht.classes.Semigroup;

using scuts.core.Functions;

class EndoInstances
{
	@:noUsing public static function monoid<T>():Monoid<T->T> return new EndoMonoid();
	@:noUsing public static function semigroup<T>():Semigroup<T->T> return new EndoSemigroup();
}

class EndoMonoid<T> extends EndoSemigroup<T> implements Monoid<T->T> {

	public function zero ():T->T
	{
		return Scuts.id;
	}
}

class EndoSemigroup<T> implements Semigroup<T->T>
{
  public function new () {}

  public function append (a:T->T, b:T->T):T->T
  {
    return a.compose(b);
  }

}
