package scuts.ht.instances.std;


import scuts.ht.core.In;
import scuts.ht.core.OfOf;
import scuts.ht.core.Of;
import scuts.core.Options;


abstract OptionTOf<M, A>(OfOf<M, Option<In>, A>) to OfOf<M, Option<In>, A> from OfOf<M, Option<In>, A> 
{

	inline function new (x:OfOf<M, Option<In>, A>) this = x;	

	@:to public inline function runT ():Of<M, Option<A>> return scuts.ht.core.Ht.preservedCast(new Of(cast this));

	@:from public static inline function intoT <M,A>(x:Of<M, Option<A>>):OptionTOf<M, A> return new OptionTOf(cast x);
	

}
