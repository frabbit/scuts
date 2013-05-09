package scuts.ht.instances.std;


import scuts.ht.core.Ht;

import scuts.ht.core.OfOf;
import scuts.ht.core.In;
import scuts.ht.core.Of;

class LazyTOfHelper {
	public static function intoT<M,T>(x:Of<M, Void->T>):LazyTOf<M,T> return new LazyTOf(cast x);	
}

abstract LazyTOf<M,T>(OfOf<M, Void->In, T>) to OfOf<M, Void->In, T> from OfOf<M, Void->In, T> 
{ 

	@:allow(scuts.ht.instances.std.LazyTOfHelper)
	inline function new (x:OfOf<M, Void->In, T>) this = x;

	@:to inline public function runT():Of<M, Void->T> return new Of(cast this);

	@:from public static inline function intoT<M,T>(x:Of<M, Void->T>):LazyTOf<M,T> return LazyTOfHelper.intoT(x);

	 

}

