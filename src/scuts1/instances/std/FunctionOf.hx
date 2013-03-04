package scuts1.instances.std;

import scuts1.core.Of;
import scuts1.core.In;

abstract Function1_2Of<A,R>(A->R) from A->R to A->R {
	
	function new (x:A->R) this = x;

	@:from static function fromOf (x:Of<A->In, R>):Function1_2Of<A,R> return new Function1_2Of(cast x);

	@:to function toOf ():Of<A->In, R> return new Of(this);
}

abstract Function1_1Of<A,R>(A->R) from A->R to A->R {

	function new (x:A->R) this = x;

	@:from static function fromOf (x:Of<In->R, A>):Function1_1Of<A,R> return new Function1_1Of(cast x);

	@:to function toOf ():Of<In->R, A> return new Of(this);
}