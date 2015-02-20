package scuts.ht.instances.std;

import scuts.ht.classes.Apply;
import scuts.ht.classes.ApplyAbstract;
import scuts.ht.classes.Applicative;

using scuts.ht.syntax.Arrays;

class ArrayApply extends ApplyAbstract<Array<In>>
{
  public function new (func) {
  	super(func);
  }

  override public function apply<B,C>(v:Array<B>, f:Array<B->C>):Array<C>
  {
    var res = [];

    for (f1 in f) for (v1 in v) res.push(f1(v1));
    return res;
  }
}
