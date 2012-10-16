package hots.instances;

import hots.classes.Bind;
import hots.In;
import hots.of.IoOf;
import scuts.core.Ios;
import scuts.core.Io;

using hots.box.IoBox;


class IoBind implements Bind<Io<In>>
{
  public function new () {}
  
  public function flatMap<A,B>(val:IoOf<A>, f: A->IoOf<B>):IoOf<B> 
  {
    return Ios.flatMap(val, f);
  }
}