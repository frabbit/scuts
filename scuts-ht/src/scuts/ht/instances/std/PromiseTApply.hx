package scuts.ht.instances.std;
import scuts.ht.classes.Applicative;
import scuts.ht.classes.Apply;
import scuts.ht.classes.ApplyAbstract;
import scuts.ht.classes.Functor;

using scuts.ht.instances.std.PromiseT;


using scuts.core.Promises;

class PromiseTApply<M> extends ApplyAbstract<PromiseT<M, _>>
{
  var functorM:Functor<M>;
  var applyM:Apply<M>;

  public function new (applyM:Apply<M>, functorM:Functor<M>, func)
  {
    super(func);
    this.applyM = applyM;
    this.functorM = functorM;
  }

  /**
   * aka <*>
   */
  override public function apply<A,B>(val:PromiseT<M,A>, f:PromiseT<M,A->B>):PromiseT<M,B>
  {
    function f1 (f:PromiseD<A->B>):PromiseD<A>->PromiseD<B>
    {
      return function (a) return f.zipWith(a, function (f1, a1) return f1(a1));
    }

    var newF = functorM.map(f.runT(), f1);

    return applyM.apply(val.runT(), newF).promiseT();
  }

}
