package scuts.ht.instances.std;

import scuts.ht.classes.Apply;
import scuts.ht.classes.ApplyAbstract;
import scuts.ht.core.In;
import scuts.ht.instances.std.IoOf;
import scuts.core.Ios;
import scuts.core.Options;




class IoApply extends ApplyAbstract<Io<In>>
{
  public function new (func) {
  	super(func);
  }
  
  override public function apply<B,C>(of:IoOf<B>, f:IoOf<B->C>):IoOf<C> 
  {
    var res = function () return f.unbox().unsafePerformIo()(of.unbox().unsafePerformIo());
    return new Io(res);
  }

}
