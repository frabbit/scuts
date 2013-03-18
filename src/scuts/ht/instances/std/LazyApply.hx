package scuts.ht.instances.std;

import scuts.core.Lazy;
import scuts.ht.classes.Apply;
import scuts.ht.classes.ApplyAbstract;
import scuts.ht.core.In;
import scuts.ht.classes.Applicative;
import scuts.ht.instances.std.LazyOf;

class LazyApply extends ApplyAbstract<Lazy<In>>
{
  public function new (func) {
  	super(func);
  }
  
  override public function apply<B,C>(v:LazyOf<B>, f:LazyOf<B->C>):LazyOf<C> 
  {
    return function () {
    	var f1:Void->(B->C) = f;
    	var v1 : Void->B = v;
    	return f1()(v1());
    }
  }
}
