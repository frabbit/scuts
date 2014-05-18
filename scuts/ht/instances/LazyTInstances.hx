
package scuts.ht.instances;

class LazyTInstances {



}

class LazyTOfHelper {
	public static function intoT<M,T>(x:Of<M, Void->T>):LazyTOf<M,T> return new LazyTOf(cast x);
}

abstract LazyTOf<M,T>(OfOf<M, Void->In, T>) to OfOf<M, Void->In, T> from OfOf<M, Void->In, T>
{

	@:allow(scuts.ht.instances.LazyTOfHelper)
	inline function new (x:OfOf<M, Void->In, T>) this = x;

	@:to inline public function runT():Of<M, Void->T> return new Of(cast this);

	@:from public static inline function intoT<M,T>(x:Of<M, Void->T>):LazyTOf<M,T> return LazyTOfHelper.intoT(x);



}



class LazyTFunctor<M> implements Functor<Of<M, Void->In>>
{
  var functorT:Functor<M>;

  public function new(f:Functor<M>)
  {
    this.functorT = f;
  }

  public function map <A,B>(x:LazyTOf<M, A>, f:A->B):LazyTOf<M,B>
  {

    function lazyMap <A,B>(x1:Lazy<A>, f:A->B):Lazy<B> return function () return f(x1());

    return functorT.map(x, lazyMap.bind(_,f));

    //return r;
  }

}