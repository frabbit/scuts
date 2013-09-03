package scuts.ht.instances.std;

import scuts.ht.core.Of;
import scuts.ht.core.In;

abstract LazyOf<T>(Void->T) from Void->T to Void->T {

	function new (x:Void->T) this = x;

	@:from public static function fromOf (x:Of<Void->In, T>):LazyOf<T> return new LazyOf(cast x);
	@:to function toOf ():Of<Void->In, T> return new Of(cast this);
	

}