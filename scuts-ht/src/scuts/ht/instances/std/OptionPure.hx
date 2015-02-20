package scuts.ht.instances.std;

import scuts.ht.classes.Pure;
import scuts.core.Options;



class OptionPure implements Pure<Option<In>>
{
  public function new () {}

  public inline function pure<B>(b:B):Option<B>
  {
    return Options.pure(b);
  }

}
