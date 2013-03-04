package scuts1.instances.std;

import scuts1.core.Of;
import scuts1.core.In;

abstract IterableOf<T>(Iterable<T>) to Iterable<T> from Iterable<T> {

	public function new (a:Iterable<T>) this = a;

	@:from static function fromOf (x:Of<Iterable<In>, T>):IterableOf<T> return new IterableOf(cast x);

	@:to function toOf ():Of<Iterable<In>, T> return new Of(this);


	public function unbox ():Iterable<T> return this;
	

}