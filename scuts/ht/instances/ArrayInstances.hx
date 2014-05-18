
package scuts.ht.instances;

import scuts.core.Arrays;
import scuts.core.Ordering;
import scuts.ht.classes.Eq;
import scuts.ht.classes.EqAbstract;
import scuts.ht.classes.FoldableAbstract;
import scuts.ht.classes.Functor;
import scuts.ht.classes.Monad;
import scuts.ht.classes.MonadEmpty;
import scuts.ht.classes.Monoid;
import scuts.ht.classes.Ord;
import scuts.ht.classes.OrdAbstract;
import scuts.ht.classes.Semigroup;
import scuts.ht.classes.Show;

typedef ArrIn = Array<In>;


class ArrayInstances {
	@:implicit @:noUsing
	public static function eq<T>(eqT:Eq<T>):Eq<Array<T>> return new ArrayEq(eqT);

  	@:implicit @:noUsing
	public static function ord<T>(ordT:Ord<T>):Ord<Array<T>> return new ArrayOrd(ordT);

	@:implicit @:noUsing
	public static function show<T>(showT:Show<T>):Show<Array<T>> return new ArrayShow(showT);

	@:implicit @:noUsing
	public static function semigroup<T>():Semigroup<Array<T>> return new ArraySemigroup();

	@:implicit @:noUsing
	public static var functor (default, null):Functor<Array<In>> = new ArrayFunctor();

	@:implicit @:noUsing
	public static var monad (default, null):Monad<Array<In>> = new ArrayMonad();
}

class ArrayEq<T> extends EqAbstract<Array<T>>
{
	var eqT:Eq<T>;

	public function new (eqT:Eq<T>)
	{
		this.eqT = eqT;
	}

	override public inline function eq	(a:Array<T>, b:Array<T>):Bool return Arrays.eq(a,b, eqT.eq);
}

class ArrayOrd<T> extends OrdAbstract<Array<T>>
{
	var ordT:Ord<T>;

	public function new (ordT:Ord<T>)
	{
		super(new ArrayEq(ordT));
		this.ordT = ordT;
	}

	override public function compare(a:Array<T>, b:Array<T>):Ordering
	{
		var smaller = a.length < b.length ? a : b;

		for (i in 0...smaller.length)
		{
			var e1 = a[i];
			var e2 = b[i];
			var r = ordT.compare(e1,e2);
			if (!r.match(EQ)) return r;
		}
		var diff = a.length - b.length;

		return if (diff < 0) LT else if (diff > 0) GT else EQ;
	}
}

class ArrayShow<T> implements Show<Array<T>>
{

	private var showT:Show<T>;

	public function new (showT:Show<T>)
	{
		this.showT = showT;
	}

	public function show (v:Array<T>):String
	{
		return "[" + v.map(function (x) return showT.show(x)).join(", ") + "]";
	}
}

class ArraySemigroup<T> implements Semigroup<Array<T>>
{
	public function new () {}

	public inline function append (a1:Array<T>, a2:Array<T>):Array<T>
	{
		return a1.concat(a2);
	}
}

class ArrayMonoid<T> extends ArraySemigroup<T> implements Monoid<Array<T>>
{
	public function new () { super();}
	public inline function zero () return [];
}

class ArrayFunctor implements Functor<ArrIn>
{
	public function new () {}

	public function map<B,C>(x:Array<B>, f:B->C):Array<C>
	{
		return Arrays.map(x, f);
	}
}

class ArrayMonad extends ArrayFunctor implements Monad<ArrIn>
{

	public function new ()
	{
		super();
	}

	public inline function flatMap<A,B>(x:Array<A>, f: A->Array<B>):Array<B>
	{
		return Arrays.flatMap(x, f);
	}

	public function flatten<A>(x:Array<Array<A>>):Array<A>
	{
		return Arrays.flatten(x);
	}

	public function pure<B>(b:B):Array<B>
	{
		return [b];
	}
}

class ArrayMonadEmpty extends ArrayMonad implements MonadEmpty<ArrIn>
{
	public inline function empty <A>():Array<A>
	{
		return [];
	}
}

class ArrayFoldable extends FoldableAbstract<ArrIn>
{
	public function new () {

	}

	override public inline function foldRight <A,B>(x:Array<A>, b:B, f:A->B->B):B
	{
		return Arrays.foldRight(x, b, f);
	}

	override public inline function foldLeft <A,B>(x:Array<B>, b:A, f:A->B->A):A
	{
		return Arrays.foldLeft(x, b, f);
	}
}

