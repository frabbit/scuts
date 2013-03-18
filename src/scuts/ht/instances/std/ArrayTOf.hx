package scuts.ht.instances.std;

import scuts.ht.core.Of;
import scuts.ht.core.In;
import scuts.ht.core.OfOf;




abstract ArrayTOf<M,A>(OfOf<M, Array<In>, A>) from OfOf<M, Array<In>, A> to OfOf<M, Array<In>, A>  
{

	inline function new (x:OfOf<M, Array<In>, A>) this = x;

	@:to public inline function runT():Of<M, Array<A>> return new Of(cast this);

	@:from public static inline function intoT<M,A>(x:Of<M, Array<A>>):ArrayTOf<M,A> return new ArrayTOf(cast x);
}
