package scuts.ht.instances.std;

import scuts.core.Lazy;

abstract LazyT<M,A>(M<Lazy<A>>)
{

	inline function new (x:M<Lazy<A>>) this = x;

	public function unwrap ():M<Lazy<A>> {
   		return this;
  	}

	public static inline function runT<M,A>(x:LazyT<M,A>):M<Lazy<A>> return x.unwrap();

	public static inline function lazyT<M,A>(x:M<Lazy<A>>):LazyT<M,A> return new LazyT(x);
}

