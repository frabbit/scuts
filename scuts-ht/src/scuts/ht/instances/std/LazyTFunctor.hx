package scuts.ht.instances.std;
import scuts.ht.classes.Functor;
using scuts.ht.instances.std.LazyT;
import scuts.core.Lazy;

class LazyTFunctor<M> implements Functor<LazyT<M, In>>
{
  var functorT:Functor<M>;

  public function new(f:Functor<M>)
  {
    this.functorT = f;
  }

  public function map <A,B>(x:LazyT<M, A>, f:A->B):LazyT<M,B>
  {

    function lazyMap <A,B>(x1:Lazy<A>, f:A->B):Lazy<B> return new Lazy(function () return f(x1()));

    return functorT.map(x.runT(), lazyMap.bind(_,f)).lazyT();

  }

}