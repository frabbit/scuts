package hots.instances;
import hots.classes.Applicative;
import hots.classes.Apply;
import hots.In;
import hots.Of;
import hots.classes.Functor;
import hots.of.PromiseTOf;
import scuts.core.Promise;

using hots.ImplicitCasts;
using hots.Hots;
using hots.Identity;

using scuts.core.Promises;

class PromiseTApply<M> implements Apply<Of<M,Promise<In>>> 
{
  var functorM:Functor<M>;
  var applyM:Apply<M>;

  public function new (applyM:Apply<M>, functorM:Functor<M>) 
  {
    
    this.applyM = applyM;
    this.functorM = functorM;
  }

  /**
   * aka <*>
   */
  public function apply<A,B>(f:PromiseTOf<M,A->B>, val:PromiseTOf<M,A>):PromiseTOf<M,B> 
  {
    function f1 (f:Promise<A->B>):Promise<A>->Promise<B>
    {
      return function (a) return f.zipWith(a, function (f1, a1) return f1(a1));
    }
    
    var newF = functorM.map(f.runT(), f1);
    
    return applyM.apply(newF, val.runT());
  }

}
