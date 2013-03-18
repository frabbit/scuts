package scuts.ht.instances.std;

import scuts.ht.classes.Pure;
import scuts.ht.core.In;
import scuts.ht.instances.std.OptionOf;
import scuts.core.Options;



class OptionPure implements Pure<Option<In>>
{
  public function new () {}
  
  public inline function pure<B>(b:B):OptionOf<B> 
  {
    return Options.pure(b);
  }
  
}
