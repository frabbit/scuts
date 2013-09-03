package scuts.ht.instances.std;

import scuts.ht.classes.Empty;
import scuts.ht.core.In;
import scuts.ht.instances.std.OptionOf;
import scuts.core.Options;


class OptionEmpty implements Empty<Option<In>>
{
  public function new () {}
  
  public inline function empty <A>():OptionOf<A> 
  {
    return None;
  }
  
}
