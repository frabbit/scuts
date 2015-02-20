package scuts.ht.instances.std;

import scuts.ht.classes.Pure;
import scuts.core.Ios;




class IoPure implements Pure<Io<In>>
{
  public function new () {}

  public inline function pure<B>(b:B):Io<B>
  {
    return Ios.pure(b);
  }

}
