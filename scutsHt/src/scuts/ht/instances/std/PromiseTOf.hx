package scuts.ht.instances.std;

import scuts.ht.core.In;
import scuts.ht.core.Of;
import scuts.ht.core.OfOf;
import scuts.core.Promises;
import scuts.ht.core.Ht;

abstract PromiseTOf<M,A>(OfOf<M, PromiseD<In>, A>) from OfOf<M, PromiseD<In>, A> to OfOf<M, PromiseD<In>, A>  
{

	public inline function new (x:OfOf<M, PromiseD<In>, A>) this = x;

	@:to public inline function runT():Of<M, PromiseD<A>> return new Of(cast this);

	@:from public static inline function intoT<M,A>(x:Of<M, PromiseD<A>>):PromiseTOf<M,A> return new PromiseTOf(cast x);
}