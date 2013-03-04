package scuts1.instances.std;

import scuts1.core.In;
import scuts1.core.Of;
import scuts.core.Promises;

abstract PromiseOf<T>(Promise<T>) to Promise<T> from Promise<T> {




	function new (a:Promise<T>) this = a;

	@:from static function fromPromise (x:Promise<T>) return new PromiseOf(x);

	@:to function toPromise ():Promise<T> return this;

	@:from static function fromOf (x:Of<Promise<In>, T>):PromiseOf<T> return new PromiseOf(cast x);

	@:to function toOf ():Of<Promise<In>, T> return new Of(this);



}
