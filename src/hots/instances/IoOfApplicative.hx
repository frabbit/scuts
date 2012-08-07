package hots.instances;

import hots.classes.ApplicativeAbstract;
import hots.In;
import scuts.core.extensions.Ios;
import scuts.core.extensions.Options;
import scuts.core.types.Io;
import scuts.core.types.Option;
import hots.instances.IoOfPointed;

using hots.box.IoBox;

class IoOfApplicative extends ApplicativeAbstract<Io<In>>
{
  public function new () 
  {
    super(IoOfPointed.get());
  }
  
  override public function apply<B,C>(f:IoOf<B->C>, of:IoOf<B>):IoOf<C> {
    var res = function () return f.unbox().unsafePerformIo()(of.unbox().unsafePerformIo());
    return new Io(res).box();
    
  }

}
