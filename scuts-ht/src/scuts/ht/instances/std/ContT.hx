package scuts.ht.instances.std;

abstract ContT<M,A>(M<Cont<A>>)
{

	inline function new (x:M<Cont<A>>) this = x;

	public function unwrap ():M<Cont<A>> {
   		return this;
  	}

	public static inline function runT<M,A>(x:ContT<M,A>):M<Cont<A>> return x.unwrap();

	public static inline function contT<M,A>(x:M<Cont<A>>):ContT<M,A> return new ContT(x);
}
