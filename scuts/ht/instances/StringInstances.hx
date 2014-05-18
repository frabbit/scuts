package scuts.ht.instances;

import scuts.ht.classes.*;

using scuts.core.Strings;

class StringInstances
{
	@:implicit @:noUsing
	public static var eq:Eq<String> = new StringEq();

	@:implicit @:noUsing
	public static var show:Show<String> = new StringShow();

	@:implicit @:noUsing
	public static var semigroup:Semigroup<String> = new StringSemigroup();

	@:implicit @:noUsing
	public static var monoid:Monoid<String> = new StringMonoid();
}

class StringEq extends EqAbstract<String>
{
	public function new () {}

	override public inline function eq (a:String, b:String):Bool return Strings.eq(a,b);
}

class StringOrd extends OrdAbstract<String>
{
	public function new (eq) super(eq);

	override public inline function lessOrEq (a:String, b:String):Bool {
		return a <= b;
	}
}

class StringSemigroup implements Semigroup<String>
{
	public function new () {}

	public inline function append (a:String, b:String):String {
		return a + b;
	}
}

class StringMonoid extends StringSemigroup implements Monoid<String>
{
	public inline function zero () return "";
}

class StringShow implements Show<String>
{
	public function new () {}

	public inline function show (v:String):String {
		return "'" + v + "'";
	}
}


