package scuts.ht.instances.std;

import scuts.ht.classes.Apply;
import scuts.ht.core.In;
import scuts.ht.core.Of;
import scuts.ht.classes.Functor;
import scuts.ht.instances.std.OptionTOf;
import scuts.core.Options;




class OptionTApply<M> implements Apply<Of<M,Option<In>>> 
{
  var functorM:Functor<M>;
  var applyM:Apply<M>;

  public function new (applyM, functorM) 
  {
    this.functorM = functorM;
    this.applyM = applyM;
  }

  /**
   * aka <*>
   */
  public function apply<A,B>(f:OptionTOf<M,A->B>, val:OptionTOf<M,A>):OptionTOf<M,B> 
  {
    function f1 (f)
    {
      return function (a) return Options.zipWith(f,a, function (f1,a1) return f1(a1));
    }
    
    var newF = functorM.map(f.runT(), f1);
    
    return applyM.apply(newF, val.runT());
  }

}
