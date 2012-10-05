package hots.instances;

import hots.classes.Apply;
import hots.In;
import hots.Of;
import hots.classes.Functor;
import hots.of.OptionTOf;
import scuts.core.extensions.Options;
import scuts.core.types.Option;

using hots.ImplicitCasts;
using hots.Hots;
using hots.Identity;

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
