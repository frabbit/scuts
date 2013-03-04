package scuts1.instances.std;

import scuts1.core.Of;
import scuts1.core.In;


//typedef ArrayOf<T> = Of<Array<In>, T>;

abstract ArrayOf<T>(Array<T>) to Array<T> from Array<T> {

	public function new (a:Array<T>) this = a;

	@:from static function fromOf (x:Of<Array<In>, T>):ArrayOf<T> return new ArrayOf(x);

	@:to function toOf ():Of<Array<In>, T> return new Of(this);


	public function unbox ():Array<T> return this;
	

}
