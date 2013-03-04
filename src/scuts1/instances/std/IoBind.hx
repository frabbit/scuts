package scuts1.instances.std;

import scuts1.classes.Bind;
import scuts1.core.In;
import scuts1.instances.std.IoOf;
import scuts.core.Ios;
import scuts.core.Io;




class IoBind implements Bind<Io<In>>
{
  public function new () {}
  
  public function flatMap<A,B>(val:IoOf<A>, f: A->IoOf<B>):IoOf<B> 
  {
    return Ios.flatMap(val, f);
  }
}