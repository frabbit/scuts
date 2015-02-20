package scuts.ht.instances.std;

import scuts.ht.core.Of;
import scuts.ht.core.In;
import scuts.ht.core.OfOf;




abstract ListTOf<M,A>(OfOf<M, List<In>, A>) from OfOf<M, List<In>, A> to OfOf<M, List<In>, A>
{

	inline function new (x:OfOf<M, List<In>, A>) this = x;

	@:to public static inline function  runT<M,A>(x:OfOf<M, List<In>, A>):M<List<A>> return new Of(cast x);

	@:from public static inline function intoT<M,A>(x:M<List<A>>):ListTOf<M,A> return new ListTOf(cast x);
}
