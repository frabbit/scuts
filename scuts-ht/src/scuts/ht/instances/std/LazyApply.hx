package scuts.ht.instances.std;

import scuts.core.Lazy;
import scuts.ht.classes.Apply;
import scuts.ht.classes.ApplyAbstract;
import scuts.ht.classes.Applicative;

class LazyApply extends ApplyAbstract<Lazy<_>>
{
  public function new (func) {
  	super(func);
  }

  override public function apply<B,C>(v:Lazy<B>, f:Lazy<B->C>):Lazy<C>
  {
    return new Lazy(function () {
    	return f()(v());
    });
  }
}
