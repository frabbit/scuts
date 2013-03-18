package scuts.ht.instances.std;

import scuts.ht.core.In;
import scuts.ht.core.Of;
import scuts.ht.core.OfOf;
import scuts.core.Promises;
import scuts.ht.core.Hots;

abstract PromiseTOf<M,A>(OfOf<M, Promise<In>, A>) from OfOf<M, Promise<In>, A> to OfOf<M, Promise<In>, A>  
{

	public inline function new (x:OfOf<M, Promise<In>, A>) this = x;

	@:to public inline function runT():Of<M, Promise<A>> return new Of(cast this);

	@:from public static inline function intoT<M,A>(x:Of<M, Promise<A>>):PromiseTOf<M,A> return new PromiseTOf(cast x);
}