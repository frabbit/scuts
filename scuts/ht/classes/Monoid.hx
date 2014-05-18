package scuts.ht.classes;

import scuts.Scuts;

interface Monoid<A> extends Semigroup<A> {
	public function zero ():A;
}