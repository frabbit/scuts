package scuts1.instances.std;

import scuts1.core.In;
import scuts1.core.Of;
import scuts.core.State;
import scuts1.core.OfOf;

abstract StateTOf<M,ST,A>(OfOf<M, State<ST, In>, A>) from OfOf<M, State<ST, In>, A> to OfOf<M, State<ST, In>, A>
{
	public inline function new (x:OfOf<M, State<ST, In>, A>) this = x;
	

	@:to inline function toOf():Of<M, State<ST,A>> return new Of(cast this);

	@:from inline static function fromOf(x:Of<M, State<ST,A>>):StateTOf<M,ST,A> return new StateTOf(cast x);

}