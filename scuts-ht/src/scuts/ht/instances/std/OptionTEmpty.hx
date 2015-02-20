package scuts.ht.instances.std;

import scuts.ht.classes.Empty;
import scuts.ht.classes.Pure;
using scuts.ht.instances.std.OptionT;

import scuts.core.Options;
import scuts.ht.classes.Monad;




class OptionTEmpty<M> implements Empty<OptionT<M,In>> {

  var pureM:Pure<M>;

  public function new (pureM:Pure<M>) {
    this.pureM = pureM;
  }

  public inline function empty <A>():OptionT<M,A>
  {
    return pureM.pure(None).optionT();
  }
}

