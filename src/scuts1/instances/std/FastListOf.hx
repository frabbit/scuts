package scuts1.instances.std;

import haxe.ds.GenericStack;
import scuts1.core.Of;
import scuts1.core.In;


abstract GenericStackOf<T>(GenericStack<T>) to GenericStack<T> from GenericStack<T> {

	public function new (a:GenericStack<T>) this = a;

	@:from static function fromOf (x:Of<GenericStack<In>, T>):GenericStackOf<T> return new GenericStackOf(cast x);

	@:to function toOf ():Of<GenericStack<In>, T> return new Of(this);


	public function unbox ():GenericStack<T> return this;
	

}