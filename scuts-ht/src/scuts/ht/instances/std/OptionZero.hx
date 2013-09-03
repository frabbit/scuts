package scuts.ht.instances.std;


import scuts.ht.classes.Zero;
import scuts.core.Options;

class OptionZero<X> implements Zero<Option<X>>
{
  
  public function new () {}
  
  
  public inline function zero ():Option<X> {
    return None;
  }
}
