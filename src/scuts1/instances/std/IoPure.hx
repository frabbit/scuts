package scuts1.instances.std;

import scuts1.classes.Pure;
import scuts1.core.In;
import scuts1.instances.std.IoOf;
import scuts.core.Ios;

import scuts.core.Io;


class IoPointed implements Pure<Io<In>>
{
  public function new () {}
  
  public inline function pure<B>(b:B):IoOf<B> 
  {
    return Ios.pure(b);
  }
  
}
