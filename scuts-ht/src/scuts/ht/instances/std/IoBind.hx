package scuts.ht.instances.std;

import scuts.ht.classes.Bind;
import scuts.ht.core.In;
import scuts.ht.instances.std.IoOf;
import scuts.core.Ios;





class IoBind implements Bind<Io<In>>
{
  public function new () {}
  
  public function flatMap<A,B>(val:IoOf<A>, f: A->IoOf<B>):IoOf<B> 
  {
    return Ios.flatMap(val, f);
  }
}