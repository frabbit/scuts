package hots.instances;

import hots.classes.Pure;
import hots.In;
import hots.of.IoOf;
import scuts.core.extensions.Ios;

import scuts.core.types.Io;


class IoPointed implements Pure<Io<In>>
{
  public function new () {}
  
  public inline function pure<B>(b:B):IoOf<B> 
  {
    return Ios.pure(b);
  }
  
}
