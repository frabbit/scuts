package hots.instances;

import hots.classes.Empty;
import hots.classes.Pure;
import hots.In;
import hots.of.OptionTOf;

import hots.Of;
import scuts.core.types.Option;
import hots.classes.Monad;

using hots.Identity;
using hots.ImplicitCasts;

class OptionTEmpty<M> implements Empty<Of<M, Option<In>>> {
  
  var pureM:Pure<M>;
  
  public function new (pureM:Pure<M>) {
    this.pureM = pureM;
  }
  
  public inline function empty <A>():OptionTOf<M,A> 
  {
    return pureM.pure(None);
  }
}

