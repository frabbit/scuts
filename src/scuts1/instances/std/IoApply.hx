package scuts1.instances.std;

import scuts1.classes.Apply;
import scuts1.core.In;
import scuts1.instances.std.IoOf;
import scuts.core.Ios;
import scuts.core.Options;
import scuts.core.Io;
import scuts.core.Option;



class IoApply implements Apply<Io<In>>
{
  public function new () {}
  
  public function apply<B,C>(f:IoOf<B->C>, of:IoOf<B>):IoOf<C> 
  {
    var res = function () return f.unbox().unsafePerformIo()(of.unbox().unsafePerformIo());
    return new Io(res);
  }

}
