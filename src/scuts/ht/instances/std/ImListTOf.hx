package scuts.ht.instances.std;

import scuts.ht.core.In;
import scuts.ht.core.OfOf;
import scuts.ht.core.Of;
import scuts.ds.ImList;

abstract ImListTOf<M,A>(Of<M, ImList<A>>) to Of<M, ImList<A>> from Of<M, ImList<A>> { 
	
	function new (x:Of<M, ImList<A>>) this = x;

	@:to function toOfOf():OfOf<M, ImList<In>, A> return new Of(cast this);

	@:from static function fromOfOf(x:OfOf<M, ImList<In>, A>):ImListTOf<M,A> return new ImListTOf(cast x);
}