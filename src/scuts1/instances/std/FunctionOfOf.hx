package scuts1.instances.std;


import scuts1.core.In;
import scuts1.core.Of;
import scuts1.core.OfOf;

abstract FunctionOfOf<A,B>(A->B) to A->B from A->B 
{
	private function new (x:A->B) this = x;

	@:from public static inline function fromOfOf (x:OfOf<In->In, A,B>):FunctionOfOf<A,B> return new FunctionOfOf(cast x);

	@:to inline function toOfOf ():OfOf<In->In, A,B> return new Of(cast this);

	public inline function unbox ():A->B return this;


}