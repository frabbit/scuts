package hots.instances;

import hots.classes.ApplicativeAbstract;
import hots.In;
import hots.classes.Applicative;
import hots.of.ArrayOf;

using hots.box.ArrayBox;

class ArrayApplicative extends ApplicativeAbstract<Array<In>>
{
  public function new (pure, func) super(pure, func)
  
  override public function apply<B,C>(f:ArrayOf<B->C>, v:ArrayOf<B>):ArrayOf<C> 
  {
    var res = [];
    for (f1 in f.unbox()) for (v1 in v.unbox()) res.push(f1(v1));
    return res.box();
  }
}
