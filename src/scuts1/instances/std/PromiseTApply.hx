package scuts1.instances.std;
import scuts1.classes.Applicative;
import scuts1.classes.Apply;
import scuts1.core.In;
import scuts1.core.Of;
import scuts1.classes.Functor;
import scuts1.instances.std.PromiseTOf;





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
    
    var newF = functorM.map(f, f1);
    
    return applyM.apply(newF, val);
  }

}
