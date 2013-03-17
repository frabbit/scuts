package scuts.ht.instances.std;

import scuts.ht.core.In;
import scuts.ht.core.Of;
import scuts.core.Options;


abstract OptionOf<T>(Option<T>) to Option<T> from Option<T>  {

	function new (x) this = x;

	@:from static function fromOption (x:Option<T>) return new OptionOf(x);

	@:to function toOption ():Option<T> return this;

	@:from static function fromOf (x:Of<Option<In>, T>):OptionOf<T> return new OptionOf(x);

	@:to function toOf ():Of<Option<In>, T> return this;

}