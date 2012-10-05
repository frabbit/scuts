package hots.instances;

import hots.classes.Apply;
import hots.In;
import hots.classes.Applicative;
import hots.of.ArrayOf;

using hots.box.ArrayBox;

class ArrayApply implements Apply<Array<In>>
{
  public function new () {}
  
  public function apply<B,C>(f:ArrayOf<B->C>, v:ArrayOf<B>):ArrayOf<C> 
  {
    var res = [];
    for (f1 in f.unbox()) for (v1 in v.unbox()) res.push(f1(v1));
    return res.box();
  }
}
