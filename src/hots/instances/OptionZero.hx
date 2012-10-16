package hots.instances;


import hots.classes.Zero;
import scuts.core.Option;

class OptionZero<X> implements Zero<Option<X>>
{
  
  public function new () {}
  
  
  public inline function zero ():Option<X> {
    return None;
  }
}
