package scuts1.instances.std;

import scuts1.classes.Empty;
import scuts1.core.In;
import scuts1.instances.std.OptionOf;
import scuts.core.Options;


class OptionEmpty implements Empty<Option<In>>
{
  public function new () {}
  
  public inline function empty <A>():OptionOf<A> 
  {
    return None;
  }
  
}
