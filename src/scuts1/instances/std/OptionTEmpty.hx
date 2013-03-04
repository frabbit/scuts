package scuts1.instances.std;

import scuts1.classes.Empty;
import scuts1.classes.Pure;
import scuts1.core.In;
import scuts1.instances.std.OptionTOf;

import scuts1.core.Of;
import scuts.core.Options;
import scuts1.classes.Monad;




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

