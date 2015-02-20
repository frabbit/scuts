package scuts.ht.instances.std;


import scuts.core.Options;

abstract OptionT<M,A>(M<Option<A>>)
{
	inline function new (x:M<Option<A>>) this = x;

	public function unwrap ():M<Option<A>> {
   		return this;
  	}

	public static inline function runT<M,A>(x:OptionT<M,A>):M<Option<A>> return x.unwrap();

	public static inline function optionT<M,A>(x:M<Option<A>>):OptionT<M,A> return new OptionT(x);
}
