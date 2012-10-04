package hots.instances;

import hots.classes.PureAbstract;
import hots.In;
import hots.of.IoOf;
import scuts.core.extensions.Ios;

import scuts.core.types.Io;


class IoPointed extends PureAbstract<Io<In>>
{
  public function new () {}
  
  override public inline function pure<B>(b:B):IoOf<B> 
  {
    return Ios.pure(b);
  }
  
}
