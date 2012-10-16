package hots.instances;

import hots.classes.Apply;
import hots.In;
import hots.of.IoOf;
import scuts.core.Ios;
import scuts.core.Options;
import scuts.core.Io;
import scuts.core.Option;

using hots.box.IoBox;

class IoApply implements Apply<Io<In>>
{
  public function new () {}
  
  public function apply<B,C>(f:IoOf<B->C>, of:IoOf<B>):IoOf<C> 
  {
    var res = function () return f.unbox().unsafePerformIo()(of.unbox().unsafePerformIo());
    return new Io(res);
  }

}
