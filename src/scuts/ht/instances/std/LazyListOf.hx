package scuts.ht.instances.std;

import scuts.ht.core.In;
import scuts.ht.core.Of;
import scuts.ds.LazyLists;

abstract LazyListOf<T>(LazyList<T>) to LazyList<T> from LazyList<T>  
{

	public function new (a:LazyList<T>) this = a;

	@:from static function fromOf (x:Of<LazyList<In>, T>):LazyListOf<T> return new LazyListOf(cast x);

	@:to function toOf ():Of<LazyList<In>, T> return cast this;
}