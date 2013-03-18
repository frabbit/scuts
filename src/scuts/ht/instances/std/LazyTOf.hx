package scuts.ht.instances.std;


import scuts.ht.core.Hots;

import scuts.ht.core.OfOf;
import scuts.ht.core.In;
import scuts.ht.core.Of;

abstract LazyTOf<M,T>(OfOf<M, Void->In, T>) to OfOf<M, Void->In, T> from OfOf<M, Void->In, T> 
{ 

	public inline function new (x:OfOf<M, Void->In, T>) this = x;

	@:to inline public function runT():Of<M, Void->T> return new Of(cast this);

	@:from public static inline function intoT<M,T>(x:Of<M, Void->T>):LazyTOf<M,T> return new LazyTOf(cast x);

	 

}

