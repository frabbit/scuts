package scuts.ht.instances.std;

import scuts.ht.classes.Apply;
import scuts.ht.classes.ApplyAbstract;

import scuts.core.Ios;
import scuts.core.Options;




class IoApply extends ApplyAbstract<Io<_>>
{
  public function new (func) {
  	super(func);
  }

  override public function apply<B,C>(of:Io<B>, f:Io<B->C>):Io<C>
  {
    var res = function () return f.unsafePerformIo()(of.unsafePerformIo());
    return new Io(res);
  }

}
