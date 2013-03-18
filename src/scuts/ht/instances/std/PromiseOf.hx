package scuts.ht.instances.std;

import scuts.ht.core.In;
import scuts.ht.core.Of;
import scuts.core.Promises;

abstract PromiseOf<T>(Promise<T>) to Promise<T> from Promise<T> {




	function new (a:Promise<T>) this = a;

	@:from static function fromPromise <T>(x:Promise<T>) return new PromiseOf(x);

	@:to function toPromise ():Promise<T> return this;

	@:from static function fromOf <T>(x:Of<Promise<In>, T>):PromiseOf<T> return new PromiseOf(cast x);

	@:to function toOf ():Of<Promise<In>, T> return new Of(this);



}
