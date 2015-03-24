package scuts.ht.instances.std;

import scuts.ds.ImLists;

abstract ImListT<M,A>(M<ImList<A>>)
{
	inline function new (x:M<ImList<A>>) this = x;

	public function unwrap ():M<ImList<A>> {
   		return this;
  	}

	public static inline function runT<M,A>(x:ImListT<M,A>):M<ImList<A>> return x.unwrap();

	public static inline function imListT<M,A>(x:M<ImList<A>>):ImListT<M,A> return new ImListT(x);
}
