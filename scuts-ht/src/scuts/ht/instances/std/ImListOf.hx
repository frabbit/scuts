package scuts.ht.instances.std;
import scuts.ht.core.In;
import scuts.ht.core.Of;
import scuts.ds.ImLists;

abstract ImListOf<T>(ImList<T>) to ImList<T> from ImList<T>  {


	public function new (a:ImList<T>) this = a;

	@:from static function fromOf (x:Of<ImList<In>, T>):ImListOf<T> return new ImListOf(cast x);

	@:to function toOf ():Of<ImList<In>, T> return cast this;

}