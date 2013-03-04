package scuts1.instances.std;

import scuts1.core.Of;
import scuts1.core.In;
import scuts1.core.OfOf;




abstract ListTOf<M,A>(OfOf<M, List<In>, A>) from OfOf<M, List<In>, A> to OfOf<M, List<In>, A>  
{

	inline function new (x:OfOf<M, List<In>, A>) this = x;

	@:to public static inline function  runT<M,A>(x:OfOf<M, List<In>, A>):Of<M, List<A>> return new Of(cast x);

	@:from public static inline function intoT<M,A>(x:Of<M, List<A>>):ListTOf<M,A> return new ListTOf(cast x);
}
