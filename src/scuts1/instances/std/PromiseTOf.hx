package scuts1.instances.std;

import scuts1.core.In;
import scuts1.core.Of;
import scuts1.core.OfOf;
import scuts.core.Promises;
import scuts1.core.Hots;

abstract PromiseTOf<M,A>(OfOf<M, Promise<In>, A>) from OfOf<M, Promise<In>, A> to OfOf<M, Promise<In>, A>  
{

	public inline function new (x:OfOf<M, Promise<In>, A>) this = x;

	@:to public inline function runT():Of<M, Promise<A>> return new Of(cast this);

	@:from public static inline function intoT<M,A>(x:Of<M, Promise<A>>):PromiseTOf<M,A> return new PromiseTOf(cast x);
}