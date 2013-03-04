package scuts1.instances.std;

import scuts1.classes.Apply;
import scuts1.core.In;
import scuts1.core.Of;
import scuts1.classes.Functor;
import scuts1.instances.std.OptionTOf;
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
