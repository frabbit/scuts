package scuts.ht.instances.std;


abstract ListT<M,A>(M<List<A>>)
{

	inline function new (x:M<List<A>>) this = x;

	public function unwrap ():M<List<A>> {
   		return this;
  	}

	public static inline function runT<M,A>(x:ListT<M,A>):M<List<A>> return x.unwrap();

	public static inline function listT<M,A>(x:M<List<A>>):ListT<M,A> return new ListT(x);
}
