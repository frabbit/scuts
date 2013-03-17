package scuts.ht.instances.std;
import scuts.ht.classes.Applicative;
import scuts.ht.classes.Apply;
import scuts.ht.classes.ApplyAbstract;
import scuts.ht.core.In;
import scuts.ht.core.Of;
import scuts.ht.classes.Functor;
import scuts.ht.instances.std.PromiseTOf;





using scuts.core.Promises;

class PromiseTApply<M> extends ApplyAbstract<Of<M,Promise<In>>> 
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
  override public function apply<A,B>(val:PromiseTOf<M,A>, f:PromiseTOf<M,A->B>):PromiseTOf<M,B> 
  {
    function f1 (f:Promise<A->B>):Promise<A>->Promise<B>
    {
      return function (a) return f.zipWith(a, function (f1, a1) return f1(a1));
    }
    
    var newF = functorM.map(f, f1);
    
    return applyM.apply(val, newF);
  }

}
