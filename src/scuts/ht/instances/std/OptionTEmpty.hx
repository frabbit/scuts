package scuts.ht.instances.std;

import scuts.ht.classes.Empty;
import scuts.ht.classes.Pure;
import scuts.ht.core.In;
import scuts.ht.instances.std.OptionTOf;

import scuts.ht.core.Of;
import scuts.core.Options;
import scuts.ht.classes.Monad;




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

