package scuts1.instances.std;
import scuts1.core.In;

import scuts1.core.Of;
import scuts1.core.OfOf;


abstract KleisliOf<M,A,B>(A->Of<M,B>) to A -> Of<M, B> from A->Of<M,B> {

	private function new (x) this = x;

	@:from static function fromOfOf (x:OfOf<In->Of<M, In>, A, B>):KleisliOf<M,A,B> return cast x;

	@:to function toOfOf ():OfOf<In->Of<M, In>, A, B> return cast this;

	public inline function unbox ():A->Of<M, B> return this;

}
