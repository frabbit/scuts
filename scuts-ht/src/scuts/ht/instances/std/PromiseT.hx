package scuts.ht.instances.std;

import scuts.core.Promises;
import scuts.ht.core.Ht;


abstract PromiseT<M,A>(M<Promise<A>>)
{

	inline function new (x:M<Promise<A>>) this = x;

	public function unwrap ():M<Promise<A>> {
   		return this;
  	}

	public static inline function runT<M,A>(x:PromiseT<M,A>):M<Promise<A>> return x.unwrap();

	public static inline function promiseT<M,A>(x:M<Promise<A>>):PromiseT<M,A> return new PromiseT(x);
}