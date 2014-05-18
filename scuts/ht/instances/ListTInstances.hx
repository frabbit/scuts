
package scuts.ht.instances;

class ListTInstances {



}

abstract ListTOf<M,A>(OfOf<M, List<In>, A>) from OfOf<M, List<In>, A> to OfOf<M, List<In>, A>
{

	inline function new (x:OfOf<M, List<In>, A>) this = x;

	@:to public static inline function  runT<M,A>(x:OfOf<M, List<In>, A>):Of<M, List<A>> return new Of(cast x);

	@:from public static inline function intoT<M,A>(x:Of<M, List<A>>):ListTOf<M,A> return new ListTOf(cast x);
}


class ListTFunctor<M> implements Functor<Of<M,List<In>>>
{
  var functorM:Functor<M>;

  public function new (functorM:Functor<M>)
  {
    this.functorM = functorM;
  }

  public function map<A,B>(v:ListTOf<M, A>,f:A->B):ListTOf<M, B>
  {

    return functorM.map(v, Lists.map.bind(_,f));
  }
}