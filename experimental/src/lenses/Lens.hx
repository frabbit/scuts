package lenses;

using scuts.core.Functions;

import scuts.core.Options;

enum Lens<A,B> {
	Lens(get:A->B, set:A->B->A);
}

class Lenses {


	public static function get <A,B>(lens:Lens<A,B>, a:A):B 
	{
		return switch (lens) 
		{
			case Lens(get,_): get(a);
		}
	}

	public static function set <A,B>(lens:Lens<A,B>, a:A, b:B):A 
	{
		return switch (lens) 
		{
			case Lens(_,set): set(a,b);
		}
	}

	public static function mod<A,B>(l:Lens<A,B>, a:A, f: B -> B) : A return set(l, a, f(get(l, a)));


	public static function liftOption<A,B>(l:Lens<A,B>):Lens<Option<A>,Option<B>> {

		return switch (l) {
			case Lens(get, set):
				function g (v:Option<A>) return switch (v) {
					case Some(a): Some(get(a));
					case None: None;
				}
				function s (a:Option<A>,b:Option<B>):Option<A> return switch [a,b] {
					case [Some(a1), Some(b1)]: Some(set(a1,b1));
					case [_,_]: None;
				}
				Lens(g,s);
		}
	}

	public static function andThen <A,B,C>(lensA:Lens<A,B>, lensB:Lens<B,C>):Lens<A,C>
	{
		return switch [lensA, lensB] {
			case [Lens(g1,s1), Lens(g2, s2)]: 
				// g1 : A->B, g2 B->C
				// s1 : A->B->A, s2 : B->C->B
				var get:A->C = g1.next(g2);
				var set:A->C->A = function (a:A, c:C):A {
					var h1 = s1.bind(a,_); // B->A
					var h2 = s2.bind(_, c); // B->B
					return h2.next(h1)(g1(a));

				}
				
				
				// var set = s1.compose(s2);
				// $type(get);
				// $type(set);
				// Lens(get, set);
				return Lens(get,set);
		}
	} 
}