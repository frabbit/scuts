package scuts.ht.instances.std;

import scuts.core.Conts;

abstract ContT<M,R, A>(M<Cont<R,A>>)
{

	inline function new (x:M<Cont<R,A>>) this = x;

	public function unwrap ():M<Cont<R,A>> {
   		return this;
  	}

	public static inline function runT<M,R,A>(x:ContT<M,R,A>):M<Cont<R,A>> return x.unwrap();

	public static inline function contT<M,R,A>(x:M<Cont<R,A>>):ContT<M,R,A> return new ContT(x);
}
