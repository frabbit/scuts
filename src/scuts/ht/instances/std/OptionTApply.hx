package scuts.ht.instances.std;

import scuts.ht.classes.Apply;
import scuts.ht.classes.ApplyAbstract;
import scuts.ht.core.In;
import scuts.ht.core.Of;
import scuts.ht.classes.Functor;
import scuts.ht.instances.std.OptionTOf;
import scuts.core.Options;




class OptionTApply<M> extends ApplyAbstract<Of<M,Option<In>>> 
{
  var functorM:Functor<M>;
  var applyM:Apply<M>;

  public function new (applyM, functorM, func) 
  {
    super(func);
    this.functorM = functorM;
    this.applyM = applyM;
  }

  /**
   * aka <*>
   */
  override public function apply<A,B>(val:OptionTOf<M,A>, f:OptionTOf<M,A->B>):OptionTOf<M,B> 
  {
    function f1 (f)
    {
      return function (a) return Options.zipWith(f,a, function (f1,a1) return f1(a1));
    }
    
    var newF = functorM.map(f.runT(), f1);
    
    return applyM.apply(val.runT(), newF);
  }

}
