package scuts1.instances.std;

import scuts1.core.Of;
import scuts1.core.In;

abstract ListOf<T>(List<T>) to List<T> from List<T> {

	public function new (a:List<T>) this = a;

	@:from static function fromOf (x:Of<List<In>, T>):ListOf<T> return new ListOf(x);

	@:to function toOf ():Of<List<In>, T> return new Of(this);


	public function unbox ():List<T> return this;
	

}