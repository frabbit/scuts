package scuts.ht.instances.std;


abstract ArrayT<M,A>(M<Array<A>>)
{

	inline function new (x:M<Array<A>>) this = x;

	public function unwrap ():M<Array<A>> {
   		return this;
  	}

	public static inline function runT<M,A>(x:ArrayT<M,A>):M<Array<A>> return x.unwrap();

	public static inline function arrayT<M,A>(x:M<Array<A>>):ArrayT<M,A> return new ArrayT(x);
}
