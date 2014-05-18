
package scuts.ht.instances;

using scuts.core.Options;

import haxe.ds.Option;
import scuts.core.Ordering;

import scuts.ht.classes.*;

class OptionInstances
{
	@:implicit @:noUsing
	public static function eq<T>(eqT:Eq<T>):Eq<Option<T>> return new OptionEq(eqT);

	@:implicit @:noUsing
	public static function show<T>(showT:Show<T>):Show<Option<T>> return new OptionShow(showT);

	@:implicit @:noUsing
	public static function ord<T>(ordT:Ord<T>):Ord<Option<T>> return new OptionOrd(ordT, eq(ordT));

	@:implicit @:noUsing
	public static function monoid<T>(semiT:Semigroup<T>):Monoid<Option<T>> return new OptionMonoid(semiT);

	@:implicit @:noUsing
	public static function semigroup<T>(semiT:Semigroup<T>):Semigroup<Option<T>> return monoid(semiT);

	@:implicit @:noUsing
	public static var monadEmpty(default,null):MonadEmpty<Option<In>> = new OptionMonadEmpty();

	@:implicit @:noUsing
	public static var monad(default,null):Monad<Option<In>> = monadEmpty;

	@:implicit @:noUsing
	public static var functor(default,null):Functor<Option<In>> = monadEmpty;
}


class OptionEq<T> extends EqAbstract<Option<T>>
{
	var eqT:Eq<T>;

	public function new (eqT:Eq<T>)
	{
		this.eqT = eqT;
	}

	override public function eq  (a:Option<T>, b:Option<T>):Bool
	{
		return Options.eq(a,b, eqT.eq);
	}
}


class OptionMonadEmpty implements MonadEmpty<Option<In>>
{
	public function new () {}

	public function map<A,B>(x:Option<A>, f:A->B):Option<B> {
		return Options.map(x, f);
	}

	public inline function empty <A>():Option<A>
	{
		return None;
	}
	public inline function flatMap<A,B>(x:Option<A>, f: A->Option<B>):Option<B>
	{
		return Options.flatMap(x, f);
	}

	public inline function pure<B>(b:B):Option<B>
	{
		return Options.pure(b);
	}

	public inline function flatten<B>(b:Option<Option<B>>):Option<B>
	{
		return Options.flatten(b);
	}
}

class OptionOrd<T> extends OrdAbstract<Option<T>>
{
	var ordT:Ord<T>;

	public function new (ordT, eq)
	{
		super(eq);
		this.ordT = ordT;
	}

	override public function compare(a:Option<T>, b:Option<T>):Ordering
	{
		return Options.compareBy(a,b, ordT.compare);
	}
}

class OptionMonoid<X> implements Monoid<Option<X>>
{
	var semi:Semigroup<X>;

	public function new (semi)
	{
		this.semi = semi;
	}

	public inline function append (a1:Option<X>, a2:Option<X>):Option<X>
	{
		return Options.append(a1, a2, semi.append);
	}

	public inline function zero ():Option<X> {
		return None;
	}
}


class OptionShow<T> implements Show<Option<T>>
{
	private var showT:Show<T>;

	public function new (showT:Show<T>)
	{
		this.showT = showT;
	}

	public function show (v:Option<T>):String return switch (v)
	{
		case Some(s): "Some(" + showT.show(s) + ")";
		case None: "None";
	}
}
