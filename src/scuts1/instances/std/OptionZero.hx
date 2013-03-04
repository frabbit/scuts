package scuts1.instances.std;


import scuts1.classes.Zero;
import scuts.core.Options;

class OptionZero<X> implements Zero<Option<X>>
{
  
  public function new () {}
  
  
  public inline function zero ():Option<X> {
    return None;
  }
}
