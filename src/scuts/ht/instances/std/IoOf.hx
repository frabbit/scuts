package scuts.ht.instances.std;

import scuts.ht.core.In;
import scuts.ht.core.Of;

import scuts.core.Ios;

abstract IoOf<T>(Io<T>) to Io<T> from Io<T> {

	public function new (a:Io<T>) this = a;

	@:from static function fromOf (x:Of<Io<In>, T>):IoOf<T> return new IoOf(cast x);

	@:to function toOf ():Of<Io<In>, T> return new Of(this);


	public function unbox ():Io<T> return this;
	

}