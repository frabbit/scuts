package scuts.ht.instances.std;

import scuts.ht.classes.Pure;
import scuts.ht.core.In;
import scuts.ht.instances.std.IoOf;
import scuts.core.Ios;




class IoPure implements Pure<Io<In>>
{
  public function new () {}
  
  public inline function pure<B>(b:B):IoOf<B> 
  {
    return Ios.pure(b);
  }
  
}
