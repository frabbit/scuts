package scuts.ht.instances.std;

import scuts.ht.classes.Apply;
import scuts.ht.core.In;
import scuts.ht.instances.std.IoOf;
import scuts.core.Ios;
import scuts.core.Options;




class IoApply implements Apply<Io<In>>
{
  public function new () {}
  
  public function apply<B,C>(f:IoOf<B->C>, of:IoOf<B>):IoOf<C> 
  {
    var res = function () return f.unbox().unsafePerformIo()(of.unbox().unsafePerformIo());
    return new Io(res);
  }

}
