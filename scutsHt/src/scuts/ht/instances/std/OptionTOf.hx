package scuts.ht.instances.std;


import scuts.ht.core.In;
import scuts.ht.core.OfOf;
import scuts.ht.core.Of;
import scuts.core.Options;

class OptionTOfHelper {
	public static function intoT <M,A>(x:Of<M, Option<A>>):OptionTOf<M, A> return new OptionTOf(cast x);	
}

abstract OptionTOf<M, A>(OfOf<M, Option<In>, A>) to OfOf<M, Option<In>, A> from OfOf<M, Option<In>, A> 
{
	@:allow(scuts.ht.instances.std.OptionTOfHelper)
	inline function new (x:OfOf<M, Option<In>, A>) this = x;	

	@:to public static inline function runT <M,A>(x:OfOf<M, Option<In>, A>):Of<M, Option<A>> return cast x;

	@:from public static inline function intoT <M,A>(x:Of<M, Option<A>>):OptionTOf<M, A> return OptionTOfHelper.intoT(x);
	

}
