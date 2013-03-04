package scuts1.instances.std;

import scuts1.core.In;
import scuts1.core.Of;
import scuts.core.Tuples;
import scuts.core.States;


abstract StateOf<S,T>(State<S,T>) to State<S,T> from State<S,T> {

	function new (x:State<S,T>) this = x;

	@:from static function fromOf (x:Of<State<S,In>, T>):StateOf<S,T> return new StateOf(cast x);

	@:to function toOf ():Of<State<S,In>, T> return new Of(cast this);

	public function unbox ():State<S,T> return this;	

}