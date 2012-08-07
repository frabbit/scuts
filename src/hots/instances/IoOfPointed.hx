package hots.instances;

import hots.classes.PointedAbstract;
import hots.In;
import hots.instances.IoOf;
import scuts.core.extensions.Ios;

import scuts.core.types.Io;


using hots.box.IoBox;

class IoOfPointed extends PointedAbstract<Io<In>>
{
  public function new () 
  {
    super(IoOfFunctor.get());
  }
  
  override public inline function pure<B>(b:B):IoOf<B> 
  {
    return Ios.pure(b).box();
  }
  
}
