package hots.instances;

import hots.classes.Empty;
import hots.In;
import hots.of.OptionOf;
import scuts.core.Option;


class OptionEmpty implements Empty<Option<In>>
{
  public function new () {}
  
  public inline function empty <A>():OptionOf<A> 
  {
    return None;
  }
  
}
