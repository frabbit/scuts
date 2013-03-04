package scuts1.instances.std;

import scuts1.classes.Pure;
import scuts1.core.In;
import scuts1.instances.std.OptionOf;
import scuts.core.Options;



class OptionPure implements Pure<Option<In>>
{
  public function new () {}
  
  public inline function pure<B>(b:B):OptionOf<B> 
  {
    return Options.pure(b);
  }
  
}
