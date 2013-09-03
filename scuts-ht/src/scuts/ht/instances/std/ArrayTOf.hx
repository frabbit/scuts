package scuts.ht.instances.std;

import scuts.ht.core.Of;
import scuts.ht.core.In;
import scuts.ht.core.OfOf;


class ArrayTOfHelper {
	public static function intoT<M,A>(x:Of<M, Array<A>>):ArrayTOf<M,A> return new ArrayTOf(cast x);
}


abstract ArrayTOf<M,A>(OfOf<M, Array<In>, A>) from OfOf<M, Array<In>, A> to OfOf<M, Array<In>, A>  
{
	@:allow(scuts.ht.instances.std.ArrayTOfHelper)
	inline function new (x:OfOf<M, Array<In>, A>) this = x;

	@:to public static inline function runT<M,A>(x:OfOf<M, Array<In>, A>):Of<M, Array<A>> return cast x;

	@:from public static inline function intoT<M,A>(x:Of<M, Array<A>>):ArrayTOf<M,A> return ArrayTOfHelper.intoT(x);
}
