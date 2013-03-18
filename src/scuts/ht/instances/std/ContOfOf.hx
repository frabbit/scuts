package scuts.ht.instances.std;
import scuts.ht.core.In;

import scuts.ht.core.Of;
import scuts.ht.core.OfOf;


import scuts.core.Conts;


abstract ContOfOf<R,A,B>(A->ContOf<B, R>) from A->ContOf<B, R> to A->ContOf<B, R> 
{
	private function new (x:A->ContOf<B, R>) this = x;

	@:from public static inline function fromOfOf (x:OfOf<In -> Cont<In, R>, A, B>):ContOfOf<R,A,B> return new ContOfOf(cast x);

	@:to inline function toOfOf ():OfOf<In -> Cont<In, R>, A, B> return new Of(cast this);

	public inline function unbox ():A->ContOf<B, R> return this;	

}
