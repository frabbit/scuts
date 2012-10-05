package hots.instances;

import hots.classes.Functor;

import hots.In;
import hots.Of;
import hots.of.OptionTOf;
import scuts.core.extensions.Options;

import scuts.core.types.Option;

using hots.ImplicitCasts;
using hots.Hots;
using hots.Identity;

class OptionTFunctor<M> implements Functor<Of<M, Option<In>>> {
  
  var functorM:Functor<M>;
  
  public function new (functorM:Functor<M>) 
  {
    this.functorM = functorM;
  }

  public function map<A,B>(v:OptionTOf<M, A>, f:A->B):OptionTOf<M, B> 
  {
    function f1 (x) return Options.map(x, f);

    return functorM.map(v.runT(), f1);
  }
}
