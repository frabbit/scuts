package scuts.ht.instances.std;

import scuts.ht.core.In;
import scuts.ht.core.Of;
import scuts.ht.core.OfOf;
import scuts.core.Promises;
import scuts.ht.core.Ht;

class PromiseTOfHelper {
	public static function intoT<M,A>(x:Of<M, PromiseD<A>>):PromiseTOf<M,A> return new PromiseTOf(cast x);
}

abstract PromiseTOf<M,A>(OfOf<M, PromiseD<In>, A>) from OfOf<M, PromiseD<In>, A> to OfOf<M, PromiseD<In>, A>  
{
	@:allow(scuts.ht.instances.std.PromiseTOfHelper)
	inline function new (x:OfOf<M, PromiseD<In>, A>) this = x;

	@:to public static inline function runT<M,A>(x:OfOf<M, PromiseD<In>, A>):Of<M, PromiseD<A>> return cast x;

	@:from public static inline function intoT<M,A>(x:Of<M, PromiseD<A>>):PromiseTOf<M,A> return PromiseTOfHelper.intoT(x);
}