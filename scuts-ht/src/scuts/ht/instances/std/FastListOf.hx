package scuts.ht.instances.std;

import haxe.ds.GenericStack;
import scuts.ht.core.Of;
import scuts.ht.core.In;


abstract GenericStackOf<T>(GenericStack<T>) to GenericStack<T> from GenericStack<T> {

	public function new (a:GenericStack<T>) this = a;

	@:from static function fromOf (x:Of<GenericStack<In>, T>):GenericStackOf<T> return new GenericStackOf(cast x);

	@:to function toOf ():Of<GenericStack<In>, T> return new Of(this);


	public function unbox ():GenericStack<T> return this;
	

}