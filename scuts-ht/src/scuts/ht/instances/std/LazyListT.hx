package scuts.ht.instances.std;

import scuts.ht.core.In;
import scuts.ht.core.OfOf;
import scuts.ht.core.Of;
import scuts.ds.LazyLists;

abstract LazyListTOf<M,A>(M<LazyList<A>>) to M<LazyList<A>> from M<LazyList<A>> {

	private function new (x) this = x;

	@:to function toOfOf():OfOf<M, LazyList<In>, A> return new Of(cast this);

	@:from static function fromOfOf(x:OfOf<M, LazyList<In>, A>):LazyListTOf<M,A> return new LazyListTOf(cast x);

}