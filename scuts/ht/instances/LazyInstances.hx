
package scuts.ht.instances;

abstract LazyOf<T>(Void->T) from Void->T to Void->T {

	function new (x:Void->T) this = x;

	@:from public static function fromOf (x:Of<Void->In, T>):LazyOf<T> return new LazyOf(cast x);
	@:to function toOf ():Of<Void->In, T> return new Of(cast this);


}

class LazyInstances {



}

class LazyFunctor implements Functor<Lazy<In>>
{
  public function new () {}

  public function map<B,C>(x:LazyOf<B>, f:B->C):LazyOf<C>
  {
  	var x1 : Void -> B = x;
    return function () return f(x1());
  }
}

class LazyPure implements Pure<Lazy<In>>
{
  public function new () {}

  public function pure<B>(b:B):LazyOf<B>
  {
    return function () return b;
  }
}
