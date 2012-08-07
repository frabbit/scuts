package hots.instances;

import hots.classes.MonadAbstract;
import hots.In;
import scuts.core.extensions.Ios;
import scuts.core.types.Io;
import hots.instances.IoOfApplicative;

using hots.box.IoBox;


class IoOfMonad extends MonadAbstract<Io<In>>
{
  public function new () super(IoOfApplicative.get())
  
  override public function flatMap<A,B>(val:IoOf<A>, f: A->IoOf<B>):IoOf<B> 
  {
    return Ios.flatMap(val.unbox(), f.unboxF()).box();
  }
}