package scuts.ht.instances.std;

import scuts.ht.core.In;
import scuts.ht.core.Of;
import scuts.core.Promises;

abstract PromiseOf<T>(PromiseD<T>) to PromiseD<T> from PromiseD<T> {




	function new (a:PromiseD<T>) this = a;

	@:from static function fromPromise <T>(x:PromiseD<T>) return new PromiseOf(x);

	@:to function toPromise ():PromiseD<T> return this;

	@:from static function fromOf <T>(x:Of<PromiseD<In>, T>):PromiseOf<T> return new PromiseOf(cast x);

	@:to function toOf ():Of<PromiseD<In>, T> return new Of(this);



}
